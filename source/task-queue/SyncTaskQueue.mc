import Toybox.Lang;
import Toybox.Timer;

/*
 * CIQ apps have a relatively small stack size, and recursive processing can easily
 * cause a stack overflow. For example, building sitemap classes for a sitemap with
 * just three levels of hierarchy can already trigger an overflow.
 *
 * To avoid this, recursive processing is replaced by iterative task-based processing.
 * This task queue facilitates that approach. For each level in a hierarchical structure,
 * new tasks are created for its sub-levels, resulting in a flat, one-dimensional list of
 * tasks that can be safely executed without risking stack overflow.
 */
class SyncTaskQueue {

    // Interface that has to be fullfiled by tasks
    typedef Task as interface {
        function invoke() as Void;
    };

    // Array for storing the tasks
    private var _tasks as Array<Task> = [];
    
    // Add a task
    public function add( task as Task ) as Void {
        _tasks.add( task );
    }

    // Add a task to the front of the queue, for cases where a task
    // should skip the line and be executed before all others
    public function addToFront( task as Task ) as Void {
        var tasks = new Array<Task>[0];
        tasks.add( task );
        if( _tasks.size() > 0 ) {
            tasks.addAll( _tasks );
        }
        _tasks = tasks;
    }

    // Execute the tasks
    public function executeTasks() as Void {
        while( _tasks.size() > 0 ) {
            var task = _tasks[0];
            task.invoke();
            _tasks.remove( task );
        }
    }
}