import Toybox.Lang;
import Toybox.Timer;

// CIQ apps are single-threaded and implement a kind of event queue,
// in which events such as user input, timers or web responses are processed.
// During the processing of an event others are blocked, which is especially
// noticable with processing of user input being delayed.
// Larger tasks should therefore be split into smaller ones and be processed
// separately, with room inbetween to execute user inputs.
// This task queue supports that. Tasks can be added to the queue and between 
// each task and the next, there will be a timer, which basically ends
// the current event processing and allows other events in the CIQ queue to
// be processed

class TaskQueue {

    // The task queue is a Singleton
    private static var _instance as TaskQueue?;
    public static function getInstance() as TaskQueue {
        if( _instance == null ) { _instance = new TaskQueue(); }
        return _instance as TaskQueue;
    }
    // Constructor is needed only to declare it private, to ensure
    // it can not be instantiated from the outside
    private function initialize() {}

    // Tasks are added as EvccTask objects
    private var _tasks as Array<Task> = [];
    
    // The timer that controls the task execution
    private var _timer as Timer.Timer = new Timer.Timer();
    
    // Starts the timer for executing tasks
    private function startTimer() as Void {
        Logger.debug( "TaskQueue: Starting timer" );
        _timer.start( method( :executeTasks ), 50, false );
    }

    // Determines if the task list ist empty
    public function isEmpty() as Boolean { return _tasks.size() == 0; }

    // Add a task
    public function add( task as Task ) as Void {
        Logger.debug( "TaskQueue: add " + _tasks.size() );
        _tasks.add( task );
        // If there were no tasks in the queue, start the timer
        if( _tasks.size() == 1 ) {
            startTimer();
        }
    }

    // Add a task to the front of the queue, for cases where a task
    // should skip the line and be executed at the next opportunity
    public function addToFront( task as Task ) as Void {
        Logger.debug( "TaskQueue: addToFront 1/" + _tasks.size() );
        var tasks = new Array<Task>[0];
        tasks.add( task );
        if( _tasks.size() > 0 ) {
            tasks.addAll( _tasks );
        } else {
            startTimer();
        }
        _tasks = tasks;
    }

    // Executes the task next in the queue and then
    // if there are remaining tasks, start the timer again
    public function executeTasks() as Void {
        Logger.debug( "TaskQueue: start executing tasks (" + _tasks.size() + " queued)" );

        try {
            var startTime = System.getTimer();

            do {
                var task = _tasks[0];
                task.invoke();
                _tasks.remove( task );
            } while ( System.getTimer() < startTime + 200 );

            Logger.debug( "TaskQueue: stop executing tasks after " + ( System.getTimer() - startTime ) + "ms (" + _tasks.size() + "remaining)" );

            if( _tasks.size() > 0 ) {
                startTimer();
            }
        } catch ( ex ) {
            // Logger.debug( "TaskQueue: registering exception" );
            removeAll();
            ExceptionHandler.handleException( ex );
        }
    }
    
    // Function to remove all tasks
    public function removeAll() as Void {
        Logger.debug( "TaskQueue: removing all tasks" );
        _tasks = new Array<Task>[0];
        _timer.stop();
    }
}
