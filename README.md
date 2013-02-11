RHTableViewProvider
===================

UITableViews wired up in three lines of code? Yes sir.

## Updates

* Now optionally draw custom views or use the default iOS cells/headers/footers with the __shouldDrawCustomViews__ property
* RHTableViewProviderEditable .. a work in progress to separate out logic for working with editable tables
* Improved custom view drawing
* More examples

## What Does It Do?

This is a set of classes to strip the UITableView boilerplate code from your view controllers, wire them up quickly, easily create complex, custom tableview setups with interchangeable cell and section styles/content.

* Wires a UITableView up in your view controller with three lines of code
* Easily provide custom objects to each cell
* Interchange custom UITableViewCell classes
* Custom drawing of cells (drawRect) if needed
* Pull to Refresh with your custom view
* Handles display of your custom 'empty state' view
* Core Data compatability setting table content with an NSFetchRequest and NSManagedObjectContext
* Interchange custom section header/footer views, populate with dynamic data
* Plays nicely with editing tables, deleting rows etc

Beyond the above, UITableView obviously offers more functionality via further delegate methods etc which I've not really found the need to package for re-use as yet. If you need to get more control and hook into the further parts of UITableView just subclass an instance of RHTableViewProvider and drop in your own delegates and notifications there as you require.


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
      self.provider = [[RHTableViewProvider alloc] initWithTableView:_tableView delegate:self];
      
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
