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


-(void)fetchData
{
    NSLog(@"fetchQutes");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //input parameters
        NSString *query = @"obama";
        NSString *endTime = @"2012-12-07";
        NSString *startTime =@"2012-10-28";
        
        //Daylife parameters
        NSString *daylife  = @"http://freeapi.daylife.com/jsonrest/publicapi/4.10/search_getRelatedArticles?";

        NSString *limit =@"10";
        NSString *accessKey = @"4d68ec63b744eec43fffad2fa9af98d1";
        NSString *signature = @"02919f7064f10403310460de2737b7ab";
        
        //Twitter parameters
        NSString *twitter = @"http://search.twitter.com/search.json?q=";
        
        
  /*    NICE TO HAVE PARAMETERS not necessary for request to work
        NSString *offset = @"&offset=";
        NSString *sort = @"relevance";
        NSString *sourceFilter =@"&source_filter_id=";
        NSString *includeImage =@"&include_image="; //add to url
        NSString *includeScores = @"&include_scores="; // add to url
        NSString *slidingExcerpt = @"&sliding_excerpt=1"; // add to url
        NSString *hasImage = @"&has_image="; // add to url
        NSString *headlineDiversity = @"&headline_diversity="; //add to url
        NSString *blockNSFW = @"&block_nsfw=";
        NSString *whiteList =@"&source_whitelist=";
        NSString *blackList =@"&source_blacklist=";
   
   
!!!TODO calculate Signature by hashing access key, shared secret and query!!!!
   
         NSString *sharedSecret = @"fd6167e10d2a54abe0206789adbaac09";
         NSString *fancySignature = [NSString stringWithFormat:@"%@%@%@",accessKey, sharedSecret, query];
         NSInteger *hashedSignature = MD5HASH(fancySignature);
         %@%@%@%@%@%@%@%@%@%@%@%@
         NSLog(@"%@", fancySignature);
         NSLog(@"%@", hashedSignature);*/
        
        //Daylife request perparation
        NSString *daylifeURLString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", daylife,@"query=", query,@"&start_time=", startTime, @"&end_time=", endTime, @"&limit=",limit, @"&accesskey=", accessKey, @"&signature=", signature];
        NSURL *daylifeURL =[NSURL URLWithString:daylifeURLString];
        NSData *daylifeData = [NSData dataWithContentsOfURL:daylifeURL];

        //Twitter request preparation
        NSString *twitterURLString = [NSString stringWithFormat:@"%@%@%@%@", twitter, query, @"%20until:", endTime];
        NSURL *twitterURL = [NSURL URLWithString:twitterURLString];
        NSData *twitterData = [NSData dataWithContentsOfURL:twitterURL];
        
        //NSerror is required for web requests
        NSError *error;
        
        twitterResponse = [NSJSONSerialization JSONObjectWithData:twitterData
                                                          options:kNilOptions
                                                            error:&error];
        daylifeResponse = [NSJSONSerialization JSONObjectWithData:daylifeData
                                                          options:kNilOptions
                                                            error:&error];

        NSLog(@"%@", twitterResponse);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        //Moving daylife data to sparate container in order to reduce duplicate code
        daylifeArticles =  [[[daylifeResponse objectForKey:@"response"]objectForKey:@"payload"] objectForKey:@"article"]; NSLog(@"%@", daylifeArticles);
        
        [self.tableView reloadData];
        
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
    self.fetchData;
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 //   self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  //  self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@", @"count of Cells");
    return 1;
}

//Number of cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    NSString *twitterText = [NSString stringWithFormat:@"%@", [[[twitterResponse objectForKey:@"results"] valueForKey:@"text"] objectAtIndex:indexPath.row]];
    NSString *twitterName = [NSString stringWithFormat:@"%@", [[[twitterResponse objectForKey:@"results"]valueForKey:@"from_user_name"] objectAtIndex:indexPath.row]];

   
    NSString *text = [NSString stringWithFormat:@"%@", [[daylifeArticles valueForKey:@"headline"] objectAtIndex:indexPath.row]];
    NSString *name =  [NSString stringWithFormat:@"%@", [[[daylifeArticles valueForKey:@"source"] valueForKey:@"name"] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", twitterName];
    cell.detailTextLabel.text = twitterText;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO
    ;
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