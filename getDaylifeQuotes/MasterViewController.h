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
    NSDictionary *daylifeArticles;
    NSDictionary *daylifeQuotes;
    NSArray *articleContainer;
    NSArray *nameContainer;
    
    
}
- (void)fetchQuotes;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end