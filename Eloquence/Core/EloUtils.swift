import Foundation

// Basically taken from: https://www.raywenderlich.com/79149/grand-central-dispatch-tutorial-swift-part-1

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE,0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
}