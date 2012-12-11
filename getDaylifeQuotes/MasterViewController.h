//
//  MasterViewController.h
//  getDaylifeQuotes
//
//  Created by Emanuel Campos on 03.11.12.
//  Copyright (c) 2012 Emanuel Campos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController{
    NSDictionary *daylifeResponse;
    NSDictionary *twitterResponse;
    NSDictionary *daylifeArticles;
    NSDictionary *daylifeQuotes;
    NSArray *articleContainer;
    NSArray *sourceContainer;

    
    
}
- (void)fetchData;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end