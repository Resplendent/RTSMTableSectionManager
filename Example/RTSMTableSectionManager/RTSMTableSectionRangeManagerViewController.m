//
//  RTSMTableSectionRangeManagerViewController.m
//  RTSMTableSectionManager
//
//  Created by Benjamin Maer on 6/16/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RTSMTableSectionRangeManagerViewController.h"

#import "RTSMTableSectionRangeManager.h"
#import "RTSMTableSectionManager.h"

#import "RUConditionalReturn.h"
#import "NSString+RUMacros.h"





typedef NS_ENUM(NSInteger, RTSMTableSectionRangeManagerViewController_tableView_sectionType) {
	RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header,
	RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_list,

	RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_header,
	RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list,
	
	RTSMTableSectionRangeManagerViewController_tableView_sectionType__first		= RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header,
	RTSMTableSectionRangeManagerViewController_tableView_sectionType__last		= RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list,
};





@interface RTSMTableSectionRangeManagerViewController () <RTSMTableSectionRangeManager_SectionLengthDelegate, UITableViewDelegate, UITableViewDataSource, RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableSectionRangeManager
@property (nonatomic, readonly, strong, nullable) RTSMTableSectionRangeManager* tableSectionRangeManager;

#pragma mark - list
@property (nonatomic, assign) NSUInteger list_top_length;
@property (nonatomic, assign) BOOL list_top_visibility;
@property (nonatomic, assign) NSUInteger list_bottom_length;
@property (nonatomic, assign) BOOL list_bottom_visibility;

#pragma mark - tableView
@property (nonatomic, readonly, strong, nullable) UITableView* tableView;
-(CGRect)tableView_frame;

#pragma mark - cell text
-(nullable NSString*)cellTextForIndexPath:(NSIndexPath*)indexPath;

@end





@implementation RTSMTableSectionRangeManagerViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	RTSMTableSectionManager* tableSectionManager = [[RTSMTableSectionManager alloc]initWithFirstSection:RTSMTableSectionRangeManagerViewController_tableView_sectionType__first
																							lastSection:RTSMTableSectionRangeManagerViewController_tableView_sectionType__last];
	[tableSectionManager setSectionDelegate:self];

	_tableSectionRangeManager = [RTSMTableSectionRangeManager new];
	[self.tableSectionRangeManager setTableSectionManager:tableSectionManager];
	[self.tableSectionRangeManager setSectionLengthDelegate:self];

	[self setList_top_length:1];
	[self setList_bottom_length:1];

	_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	[self.tableView setFrame:self.tableView_frame];
}

#pragma mark - RTSMTableSectionRangeManager_SectionLengthDelegate
-(NSUInteger)tableSectionRangeManager:(nonnull RTSMTableSectionRangeManager*)tableSectionRangeManager
					  lengthOfSection:(NSInteger)section
{
	switch ((RTSMTableSectionRangeManagerViewController_tableView_sectionType)section)
	{
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header:
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_header:
			return 1;
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_list:
			return self.list_top_length;
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list:
			return self.list_bottom_length;
			break;
	}

	NSAssert(false, @"unhandled section %li",section);
	return 0;
}

#pragma mark - list
-(void)setList_top_length:(NSUInteger)list_top_length
{
	kRUConditionalReturn(self.list_top_length == list_top_length, NO);
	kRUConditionalReturn(list_top_length < 1, YES);

	_list_top_length = list_top_length;

	[self.tableView reloadData];
}

-(void)setList_top_visibility:(BOOL)list_top_visibility
{
	kRUConditionalReturn(self.list_top_visibility == list_top_visibility, NO);

	_list_top_visibility = list_top_visibility;

	[self.tableView reloadData];
}

-(void)setList_bottom_length:(NSUInteger)list_bottom_length
{
	kRUConditionalReturn(self.list_bottom_length == list_bottom_length, NO);
	kRUConditionalReturn(list_bottom_length < 1, YES);

	_list_bottom_length = list_bottom_length;

	[self.tableView reloadData];
}

-(void)setList_bottom_visibility:(BOOL)list_bottom_visibility
{
	kRUConditionalReturn(self.list_bottom_visibility == list_bottom_visibility, NO);
	
	_list_bottom_visibility = list_bottom_visibility;
	
	[self.tableView reloadData];
}

#pragma mark - tableView
-(CGRect)tableView_frame
{
	return self.view.bounds;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.tableSectionRangeManager.indexPathSectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	kRUDefineNSStringConstant(tableView_dequeIdentifier)
	UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:tableView_dequeIdentifier];

	if (tableViewCell == nil)
	{
		tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableView_dequeIdentifier];
	}

	[tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[tableViewCell.textLabel setText:[self cellTextForIndexPath:indexPath]];
	[tableViewCell.detailTextLabel setText:[NSString stringWithFormat:@"section %li",indexPath.section]];

	return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RTSMTableSectionRangeManagerViewController_tableView_sectionType sectionType = [self.tableSectionRangeManager sectionForIndexPathSection:indexPath.section];
	switch (sectionType)
	{
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header:
			[self setList_top_visibility:(self.list_top_visibility == false)];
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_list:
			if (indexPath.section == [self.tableSectionRangeManager indexPathSectionForSection:sectionType])
			{
				[self setList_top_length:self.list_top_length + 1];
			}
			else
			{
				[self setList_top_length:self.list_top_length - 1];
			}
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_header:
			[self setList_bottom_visibility:(self.list_bottom_visibility == false)];
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list:
			if (indexPath.section == [self.tableSectionRangeManager indexPathSectionForSection:sectionType])
			{
				[self setList_bottom_length:self.list_bottom_length + 1];
			}
			else
			{
				[self setList_bottom_length:self.list_bottom_length - 1];
			}
			break;
	}
}

#pragma mark - RTSMTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RTSMTableSectionManager*)tableSectionManager sectionIsAvailable:(NSInteger)section
{
	switch ((RTSMTableSectionRangeManagerViewController_tableView_sectionType)section)
	{
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header:
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_header:
			return YES;
			break;
			
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_list:
			return self.list_top_visibility;
			break;
			
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list:
			return self.list_bottom_visibility;
			break;
	}
	
	NSAssert(false, @"unhandled section %li",section);
	return 0;
}

#pragma mark - cell text
-(nullable NSString*)cellTextForIndexPath:(NSIndexPath*)indexPath
{
	RTSMTableSectionRangeManagerViewController_tableView_sectionType sectionType = [self.tableSectionRangeManager sectionForIndexPathSection:indexPath.section];
	switch (sectionType)
	{
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_header:
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_header:
			return @"Tap to toggle section visibility";
			break;

		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_top_list:
		case RTSMTableSectionRangeManagerViewController_tableView_sectionType_bottom_list:
			return ((indexPath.section == [self.tableSectionRangeManager indexPathSectionForSection:sectionType]) ?
					@"Tap to add" : @"Tap to remove");
			break;
	}
}

@end
