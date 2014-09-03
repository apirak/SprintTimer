//
//  UXATimePickerViewController.m
//  SprintTimer
//
//  Created by Apirak Panatkool on 9/2/2557 BE.
//  Copyright (c) 2557 Apirak Panatkool. All rights reserved.
//

#import "UXATimePickerViewController.h"


@interface UXATimePickerViewController (){
    NSArray *_names;
    NSArray *_seconds;
    NSIndexPath *_selectedRow;
}
@end

@implementation UXATimePickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Initialize the array
        _timeNames = [NSMutableArray array];
        
        //Set up the array of colors.
        [_timeNames addObject:@"30 Second"];
        [_timeNames addObject:@"1 Min"];
        [_timeNames addObject:@"2 Min"];
        
        
        // Values and keys as arrays
        _names = @[@"30 second",
                            @"1 Min",
                            @"2 Min",
                            @"3 Min",
                            @"5 Min",
                            @"8 Min",
                            @"13 Min",
                            @"21 Min",
                            @"30 Min",
                            @"60 min"];
        
        _seconds = @[[NSNumber numberWithInt:30],
                           [NSNumber numberWithInt:1*60],
                           [NSNumber numberWithInt:2*60],
                           [NSNumber numberWithInt:3*60],
                           [NSNumber numberWithInt:5*60],
                           [NSNumber numberWithInt:8*60],
                           [NSNumber numberWithInt:13*60],
                           [NSNumber numberWithInt:21*60],
                           [NSNumber numberWithInt:30*60],
                           [NSNumber numberWithInt:60*60]];
        
        _timeNamesValue = [NSDictionary dictionaryWithObjects:_seconds forKeys:_names];
        
        //Make row selections persist.
        self.clearsSelectionOnViewWillAppear = NO;

        
        NSInteger rowsCount = [_timeNamesValue count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        //Calculate how wide the view should be by finding how wide each string is expected to be
        CGFloat largestLabelWidth = 0;
        for (NSString *timeName in _names) {
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
    return [_names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.text = [_names objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedTimeName = [_names objectAtIndex:indexPath.row];
    _selectedRow = indexPath;
    
    int time = (int)[_timeNamesValue[selectedTimeName] integerValue];
    if (_delegate != nil) {
        [_delegate selectedTime:time withLabel:selectedTimeName];
    }
}

@end
