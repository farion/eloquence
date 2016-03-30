import Foundation

#if os(iOS)
    typealias EloFetchedResultsController = NSFetchedResultsController
    typealias EloFetchedResultsControllerDelegate = NSFetchedResultsControllerDelegate
    typealias EloFetchedResultsChangeType = NSFetchedResultsChangeType
#else
    import KSPFetchedResultsController
    typealias EloFetchedResultsController = KSPFetchedResultsController
    typealias EloFetchedResultsControllerDelegate = KSPFetchedResultsControllerDelegate
    typealias EloFetchedResultsChangeType = KSPFetchedResultsChangeType
#endif