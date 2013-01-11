RHTableViewProvider
===================

A class to strip all the UITableView boilerplate code from your view controllers.

* Easily provide custom objects to each cell
* Interchange custom UITableViewCell classes
* Pull to Refresh with your custom view
* Handles display of your custom 'empty state' view

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

* This is currently best for more static tableViews and menus, I'll be re-implementing a version of 'cellForRowAtIndexPath' to lazy load in cells/sections without the boilerplate.
* I have a simple version of this for Core Data working with, NSFetchedResultsController which I will probably add as a separate repo.
* The idea behind this probably doesn't apply to editable tables but I'll have a go!
* Add the option to use iOS 6 pull-to-refresh instead of the custom view