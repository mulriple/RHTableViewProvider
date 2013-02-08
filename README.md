RHTableViewProvider
===================

UITableViews wired up in three lines of code? Yes sir.

A set of classes to strip all the UITableView boilerplate code from your view controllers and get you wired up fast.

## Updates

* Now optionally draw custom views or use the default iOS cells/headers/footers with the _shouldDrawCustomvViews property
* RHTableViewProviderEditable .. a work in progress to separate out logic for working with editable tables
* Improved custom view drawing

## What Does It Do?

* Easily provide custom objects to each cell
* Interchange custom UITableViewCell classes
* Pull to Refresh with your custom view
* Handles display of your custom 'empty state' view
* Core Data compatability setting table content with an NSFetchRequest and NSManagedObjectContext
* Interchange custom section header/footer views, populate with dynamic data
* Plays nicely with editing tables, deleting rows etc

## Sample Usage

    @interface ViewController ()

    @property (strong, nonatomic) RHTableViewProvider *provider;
    @property (strong, nonatomic) UITableView *tableView;

    @end

    @implementation ViewController

    - (void)viewDidLoad
    {
      [super viewDidLoad];
      
      // Create a table view and add it to your view (Conveinience)
      self.tableView = [RHTableViewProvider tableViewWithFrame:self.view.bounds style:UITableViewStylePlain forSuperView:self.view];
      
      // Setup your table view provider
      self.provider = [[RHTableViewProviderEditable alloc] initWithTableView:_tableView delegate:self];
      
      // Update your content
      [_provider setContent:@[@"One", @"Two", @"Three"] withSections:NO];
    }

    #pragma mark - RHTableViewProviderDelegate

    - (void)RHTableViewProvider:(RHTableViewProvider *)provider didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
      id object = [provider objectAtIndexPath:indexPath];
      NSLog(@"Hello Object: %@", object);
    }

    @end

## TODOs

* This is currently best for more static tableViews and menus, I'll be re-implementing a version of 'cellForRowAtIndexPath' to lazy load in cells/sections without the boilerplate. (Adding a 'cell datasource' for the lazy loading, set default datasource as the provider not the view controller)
* Add the option to use iOS 6 pull-to-refresh instead of the custom view ( I kind of like custom ones though but hey :)
* Better editable tableview examples