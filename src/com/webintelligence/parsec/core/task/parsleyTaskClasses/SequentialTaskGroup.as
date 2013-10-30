package com.webintelligence.parsec.core.task.parsleyTaskClasses
{
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.task.enum.TaskState;

/**
 * A TaskGroup implementation that executes its child Tasks sequentially.
 * When the last child Task has completed its operation this TaskGroup will fire its
 * <code>COMPLETE</code> event. If the TaskGroup gets cancelled or suspended the currently active child
 * task will also be cancelled or suspended in turn.
 * If a child Task throws an <code>ERROR</code> event and the <code>ignoreChildErrors</code> property
 * of this TaskGroup is set to false, then the TaskGroup will fire an <code>ERROR</code> event
 * and will not execute its remaining child tasks.
 * If the <code>autoStart</code> property of this TaskGroup is set to true, the TaskGroup
 * will automatically be started if a child task gets added to an empty chain.
 * 
 * @author Jens Halm
 */	
public class SequentialTaskGroup extends TaskGroup {
    
    private var currentIndex : Number;
    
    private static var logger:Logger;
    
    
    /**
     * Creates a new TaskGroup.
     * 
     * @param name an optional name for log output
     */	
    public function SequentialTaskGroup (name:String = null) {
        super();
        if (logger == null) {
            logger = LogContext.getLogger(SequentialTaskGroup);
        }
        setName((name == null) ? "[SequentialTaskGroup]" : name);
    }
    
    /**
     * @private
     */
    protected override function handleRemovedTask (t : Task, index : uint) : void {
        if (index <= currentIndex) currentIndex--;
    }
    
    /**
     * @private
     */
    protected override function handleRemoveAll () : void {
        currentIndex = 0;
    }
    
    /**
     * @private
     */
    protected override function doStart () : void {
        currentIndex = 0;
        nextTask();
    }
    
    /**
     * @private
     */
    protected override function handleTaskComplete (t:Task) : void {
        currentIndex++;
        if (state == TaskState.ACTIVE) {
            // Chain is already active so we must start the next task immediately
            nextTask();
        } else if (state == TaskState.SUSPENDED && allTasks.size() > currentIndex) {
            // Add the new task to the activeTasks List so it will be started when resuming the TaskGroup
            activeTasks.add(allTasks.getAt(currentIndex));
        }
    }
    
    private function nextTask () : void {
        if (allTasks.size() == currentIndex) {
            logger.info("Completed all tasks");
            complete();
        } else {
            var t:Task = Task(allTasks.getAt(currentIndex));
            logger.info("Starting next task: " + t);
            startTask(t);
        }
    }		
    
}

}