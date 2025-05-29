import Toybox.Lang;
import Toybox.Timer;

/*
 * CIQ apps are single-threaded and operate on an event queue.
 * Events—such as user input, timers, or web responses—are processed
 * one at a time. While one event is being processed, all others are blocked.
 * This can lead to noticeable delays, particularly in user input responsiveness.
 *
 * To prevent such delays, larger tasks should be broken into smaller units,
 * allowing time between them for other events (like user input) to be handled.
 *
 * This task queue supports that pattern. Tasks can be added to the queue, and
 * a short timer is scheduled between each task. This timer ends the current
 * event handling cycle and gives the CIQ runtime a chance to process other
 * pending events before the next task begins.
 *
 * NOTE: Currently, this task queue is designed specifically for the asynchronous
 * processing of incoming JSON data. It assumes that if any task in the sequence
 * fails with an error, all subsequent tasks will be canceled.
 */

// Interface that has to be fullfiled by tasks
typedef Task as interface {
    function invoke() as Void;
    function handleException( ex as Exception ) as Void;
};

class TaskQueue {

    // The task queue is a Singleton
    private static var _instance as TaskQueue?;
    public static function get() as TaskQueue {
        if( _instance == null ) { _instance = new TaskQueue(); }
        return _instance as TaskQueue;
    }
    // Constructor is needed only to declare it private, to ensure
    // it can not be instantiated from the outside
    private function initialize() {}

    // Tasks need to fullfil the Task interface
    private var _tasks as Array<Task> = [];
    
    // The timer that controls the task execution
    private var _timer as Timer.Timer = new Timer.Timer();
    
    // Starts the timer for executing tasks
    private function startTimer() as Void {
        // Logger.debug( "TaskQueue: starting timer" );
        _timer.start( method( :executeTasks ), 50, false );
    }

    // Determines if the task list ist empty
    public function isEmpty() as Boolean { return _tasks.size() == 0; }

    // Add a task
    public function add( task as Task ) as Void {
        // Logger.debug( "TaskQueue: add " + _tasks.size() );
        _tasks.add( task );
        // If there were no tasks in the queue, start the timer
        if( _tasks.size() == 1 ) {
            startTimer();
        }
    }

    // Add a task to the front of the queue, for cases where a task
    // should skip the line and be executed at the next opportunity
    public function addToFront( task as Task ) as Void {
        // Logger.debug( "TaskQueue: addToFront 1/" + _tasks.size() );
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
        // Logger.debug( "TaskQueue: start executing tasks (" + _tasks.size() + " queued)" );

        try {
            var startTime = System.getTimer();

            do {
                var task = _tasks[0];
                try {
                    task.invoke();
                   _tasks.remove( task );
                } catch( ex ) {
                    // Logger.debug( "TaskQueue: exception during task invocation" );
                    task.handleException( ex );
                    removeAll();
                }
            } while ( 
                System.getTimer() < startTime + 100 
                && _tasks.size() > 0
            );

            // Logger.debug( "TaskQueue: stop executing tasks after " + ( System.getTimer() - startTime ) + "ms (" + _tasks.size() + " remaining)" );

            if( _tasks.size() > 0 ) {
                startTimer();
            }
        } catch ( ex ) {
            // Logger.debug( "TaskQueue: exception during task handling" );
            removeAll();
            ExceptionHandler.handleException( ex );
        }
    }
    
    // Function to remove all tasks
    public function removeAll() as Void {
        // Logger.debug( "TaskQueue: removing all tasks" );
        _tasks = new Array<Task>[0];
        _timer.stop();
    }
}