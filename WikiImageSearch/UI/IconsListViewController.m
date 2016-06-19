//
//  IconsListViewController.m
//  WikiImageSearch
//
//  Created by Mithlesh Jha on 18/06/16.
//  Copyright © 2016 Mithlesh Jha. All rights reserved.
//

#import "IconsListViewController.h"
#import "ControllerFactory.h"
#import "IListModel.h"
#import "Utils.h"


static NSString *kIconCellIdentifier = @"iconTitleCell";
static NSString *kPlaceholderCellIdentifier = @"placeholderCell";

@interface IconsListViewController ()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) id <IAppUIController, IWikiSearchController, IIconDownloadController> searchResultsController;

- (void) _initializeSearchController;
- (void) _initializeController;

@end

@implementation IconsListViewController

- (void) _initializeSearchController {
    UISearchController *sc = [[UISearchController alloc] initWithSearchResultsController:nil];
    sc.searchResultsUpdater = self;
    sc.dimsBackgroundDuringPresentation = NO;
    [sc.searchBar sizeToFit];
    [sc.searchBar setPlaceholder:NSLocalizedString(@"Search", nil)];
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = sc.searchBar;
    self.searchController = sc;
}

- (void) _initializeController {
    //WikiSearchResultsListController *controller = [[WikiSearchResultsListController alloc] init];
    self.searchResultsController = [[ControllerFactory sharedInstance] createSearchUIController];
    self.searchResultsController.modelObserver = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initializeSearchController];
    [self _initializeController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.searchResultsController cancelIconDownloadAtIndexPath:nil];
}

- (void) dealloc {
    __unused UIView *view = self.searchController.view;
    [self.searchResultsController cancelIconDownloadAtIndexPath:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.searchResultsController listModel] numberOfSections];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ESearchContrllerStatus status = self.searchResultsController.status;
    NSString *searchText = self.searchResultsController.searchText;
    NSInteger recordsCount = [[self.searchResultsController listModel] numberOfRecordsInSection:section];
    
    NSString *sectionText = nil;
    if (status == eSearchControllerStatusIdle) {
        if (recordsCount == 0) {
            NSString *noRecordsAvailable = @"No records found";
            if ([searchText length] > 0)
                noRecordsAvailable = [noRecordsAvailable stringByAppendingFormat:@" for search term %@", searchText];
            sectionText = NSLocalizedString(noRecordsAvailable, nil);
        } else {
            NSString *format = NSLocalizedString(@"%d records found", nil);
            sectionText = [NSString stringWithFormat:format, recordsCount];
        }

    } else {
        NSString *format = NSLocalizedString(@"Searching records for %@", nil);
        sectionText = [NSString stringWithFormat:format, searchText];
    }
    
    return sectionText;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger recordsCount = [[self.searchResultsController listModel] numberOfRecordsInSection:section];
    ESearchContrllerStatus status = self.searchResultsController.status;
    if (recordsCount == 0 && status != eSearchControllerStatusIdle) {
        return 1;
    } else {
        return recordsCount;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSInteger recordsCount = [[self.searchResultsController listModel] numberOfRecordsInSection:indexPath.section];
    
    if (recordsCount == 0 && indexPath.row == 0) {
        // add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:kPlaceholderCellIdentifier forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kIconCellIdentifier forIndexPath:indexPath];
        
        if (recordsCount > 0) {
            cell.textLabel.text = [[self.searchResultsController listModel] titleForDataAtIndexPath:indexPath];
            UIImage *icon = [[self.searchResultsController listModel] iconAtIndex:indexPath];
            
            if (!icon) {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                    [self.searchResultsController startDownloadingIconAtIndexPath:indexPath];
                        
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            } else {
                cell.imageView.image = icon;
            }
        }
    }
    
    return cell;
}


#pragma mark - UISearchResultUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // No need to send request to search when user hits search bar for the first time
    if (self.searchResultsController.searchText == nil && searchController.searchBar.text.length == 0)
        return;
    
    [self.searchResultsController filterSearchResultsForSearchText:searchController.searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - UIControllerModelUpdateListener
- (void) datasetUpdated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (void) datasetUpdationFailedWithError:(NSError*)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utils handleError:error];
        [self.tableView reloadData];
    });
}

- (void) iconLoadedAtIndexpath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Display the newly loaded image
    UIImage *icon = [[self.searchResultsController listModel] iconAtIndex:indexPath];
    if (icon != nil)
        cell.imageView.image = icon;
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)loadImagesForOnscreenRows
{
    NSInteger recordsCount = [[self.searchResultsController listModel] numberOfRecordsInSection:0];
    if (recordsCount > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            UIImage *icon = [[self.searchResultsController listModel] iconAtIndex:indexPath];
            
            if (!icon) {
                if (![self.searchResultsController startDownloadingIconAtIndexPath:indexPath]) {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
                }
            }
        }
    }
}



@end
