//
//  MasterViewController.m
//  getDaylifeQuotes
//
//  Created by Emanuel Campos on 03.11.12.
//  Copyright (c) 2012 Emanuel Campos. All rights reserved.
//

#import "MasterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController;

-(void)fetchQuotes
{
    NSLog(@"fetchQutes");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Web Requet to Daylife params: mitt, start:28-10-12, end: 10-11-12
        
        NSString *daylife  = @"http://freeapi.daylife.com/jsonrest/publicapi/4.10/search_getQuotesBy?";
        NSString *query = @"mitt";
        NSString *startTime =@"2012-10-28";
        NSString *endTime = @"2012-11-17";
        NSString *offset = @"&offset=";
        NSString *limit =@"1";
        NSString *sort = @"relevance";
        NSString *sourceFilter =@"&source_filter_id=";
        NSString *blockNSFW = @"&block_nsfw=";
        NSString *whiteList =@"&source_whitelist=";
        NSString *blackList =@"&source_blacklist=";
        NSString *accessKey = @"4d68ec63b744eec43fffad2fa9af98d1";
   //                            "37d39440cfdfd32ab1375057ec9aa10e
        NSString *signature = @"b270c17b4446d0349e416fb6fda17931";

 /*       TODO calculate Signature by 
        NSString *sharedSecret = @"fd6167e10d2a54abe0206789adbaac09";
        NSString *fancySignature = [NSString stringWithFormat:@"%@%@%@",accessKey, sharedSecret, query];
        NSInteger *hashedSignature = MD5HASH(fancySignature);

        NSLog(@"%@", fancySignature);
        NSLog(@"%@", hashedSignature);
  */
        NSString *daylifeURL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", daylife,@"query=", query,@"&start_time=", startTime, @"&end_time=", endTime, offset, @"&limit=", limit,@"&sort=", sort,sourceFilter, blockNSFW, whiteList,  blackList, @"&accesskey=", accessKey, @"&signature=", signature];
        
        NSLog(@"%@", daylifeURL);
        NSURL *url =[NSURL URLWithString:daylifeURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        
        daylifeResponse = [NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            //Moving data to sparate container
            daylifeNamesQuotes =  [[[daylifeResponse objectForKey:@"response"]objectForKey:@"payload"]objectForKey:@"quote"];
     
        });
    });
    
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.fetchQuotes;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View
//Number of cells
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@", @"count of Cells");
    return 10;
}

//Number of rows per cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//Filling cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"filling cells");
    static NSString *CellIdentifier = @"qouteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//
    NSString *text =  [[daylifeNamesQuotes valueForKey:@"quote_text"]componentsJoinedByString:@""];
    NSLog(@"%@", text);
    
    NSString *name =  [[daylifeNamesQuotes valueForKey:@"name"]componentsJoinedByString:@""];
    NSLog(@"%@", name);

    cell.textLabel.text = [NSString stringWithFormat:@"by %@", name];
    cell.detailTextLabel.text = text;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end