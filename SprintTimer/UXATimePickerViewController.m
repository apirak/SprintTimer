//
//  UXATimePickerViewController.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 9/2/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXATimePickerViewController.h"

@interface UXATimePickerViewController ()

@end

@implementation UXATimePickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Initialize the array
        _timeNames = [NSMutableArray array];
        
        //Set up the array of colors.
        [_timeNames addObject:@"30 second"];
        [_timeNames addObject:@"1 min"];
        [_timeNames addObject:@"2 min"];
        
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;
        
        //Calculate how tall the view should be by multiplying the individual row height
        //by the total number of rows.
        NSInteger rowsCount = [_timeNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *timeName in _timeNames) {
            
            CGSize labelSize = [timeName sizeWithAttributes:
                           @{NSFontAttributeName:
                                 [UIFont boldSystemFontOfSize:20.0f]}];
            
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        //Add a little padding to the width
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        //Set the property to tell the popover container how big this view will be.
        [self setPreferredContentSize:CGSizeMake(popoverWidth, totalRowsHeight)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_timeNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedColorName = [_timeNames objectAtIndex:indexPath.row];
    
    //Create a variable to hold the color, making its default color
    //something annoying and obvious so you can see if you've missed
    //a case here.
    NSInteger time = 0;
    
    //Set the color object based on the selected color name.
    if ([selectedColorName isEqualToString:@"Red"]) {
        time = 1;
    } else if ([selectedColorName isEqualToString:@"Green"]){
        time = 2;
    } else if ([selectedColorName isEqualToString:@"Blue"]) {
        time = 3;
    }
    
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedTime:&time];
    }
}

@end
