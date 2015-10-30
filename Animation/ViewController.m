//
//  ViewController.m
//  Animation
//
//  Created by Scott_Mr on 15/10/29.
//  Copyright © 2015年 Scott_Mr. All rights reserved.
//

#import "ViewController.h"
#import "DIYTableViewCell.h"
#import "SecondViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *detailArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [[NSArray alloc] initWithObjects:@"UIViewAnimation",@"CABasicAnimation",@"CAKeyframeAnimation",@"CATransition",@"CAAnimationGroup", nil];
    }
    return _titleArr;
}

- (NSArray *)detailArr
{
    if (_detailArr == nil) {
        _detailArr = [[NSArray alloc] initWithObjects:@"UIView动画",@"基础动画",@"关键帧动画",@"转场动画",@"组动画", nil];
    }
    return _detailArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(separatorInset)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.titleLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.detailLabel.text = [self.detailArr objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushSegue" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SecondViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    vc.title = [self.detailArr objectAtIndex:indexPath.row];
    vc.animationType = indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
