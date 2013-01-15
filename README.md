RHTableViewProvider
===================

A set of classes to strip all the UITableView boilerplate code from your view controllers.

* Easily provide custom objects to each cell
* Interchange custom UITableViewCell classes
* Pull to Refresh with your custom view
* Handles display of your custom 'empty state' view
* Core Data compatability setting table content with an NSFetchRequest and NSManagedObjectContext
* Interchange custom section header/footer views, populate with dynamic data
* Plays nicely with editing tables, deleting rows etc

## Sample Usage

    @interface RHViewController ()

    @property (strong, nonatomic) RHTableViewProvider *provider;
    @property (strong, nonatomic) RHTableView *tableView;
    @end

    @implementation RHViewController

    - (void)viewDidLoad
    {
      [super viewDidLoad];
      [self setupTableView];
      [self fetchContent];
    }

    - (void)setupTableView
    {
      self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
      self.provider = [[RHTableViewProvider alloc] initWithTableView:self.tableView delegate:self];
      [[self view] addSubview:self.tableView];
    }

    - (void)fetchContent
    {
      NSArray *content = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
      [self.provider setContent:content withSections:NO];
    }

    #pragma mark - RHTableViewProviderDelegate

    - (void)RHTableViewProvider:(RHTableViewProvider *)provider tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
      id object = [provider objectAtIndexPath:indexPath];
      
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected" message:object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
    }

    - (NSString *)classNameForCellAtIndexPath:(NSIndexPath *)indexPath
    {
      switch (indexPath.row) {
        case 1:
          return @"CustomCell";
          break;
        default:
          return nil;
          break;
      }
    }

    @end

## TODOs

* This is currently best for more static tableViews and menus, I'll be re-implementing a version of 'cellForRowAtIndexPath' to lazy load in cells/sections without the boilerplate. (Adding a 'cell datasource' for the lazy loading, set default datasource as the provider not the view controller)
* Add the option to use iOS 6 pull-to-refresh instead of the custom view