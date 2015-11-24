//
//  HotWordsView.m
//  PersonnelFiles
//
//  Created by Simons on 15/8/13.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import "HotWordsView.h"
#import "HotWordCell.h"
#import "LoadData.h"


static NSString *headerIdentify = @"headerView";
@implementation HotWordsView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addTheView];
        [self getHotWordArrData];

    }
    return self;
}
-(void)addTheView
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.myCollerctionView];
    _hotWordsLabelSize = CGSizeMake(0, 0);

}
-(void)getHotWordArrData
{
    LoadData * loadData = [LoadData LoadDatakWithUrl:@"/gethotkey/index" WithDic:nil withCount:33];
    loadData.ReturnLoadDataWithArrBlock = ^(NSMutableArray * arr)
    {
        if (arr.count != 0) {
            _hotWordArr = arr;
            [self.myCollerctionView reloadData];
        }
    };
}
#pragma mark -- 必须实现的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotWordArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用队列中获取Cell 标识同步骤七
    HotWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotWordCellID" forIndexPath:indexPath];
    cell.hotWordLab.text = self.hotWordArr[indexPath.row];
    _hotWordsLabelSize = cell.hotWordLab.frame.size;
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lab = [UILabel new];
    lab.text = self.hotWordArr[indexPath.row];
    [lab sizeToFit];
    return CGSizeMake(lab.width , 21);

}

#pragma mark --实现单元格点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate searchWithHotWord:self.hotWordArr[indexPath.row]];
}
//设定分区头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableV = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //头部视图
        reusableV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify forIndexPath:indexPath];
        //头视图添加内容
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainWidth, 21)];
        lab.text = @"大家都在搜";
        lab.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        lab.font = [UIFont systemFontOfSize:14];
        [reusableV addSubview:lab];
        
        
    }
    return reusableV;
}

#pragma mark -- get
-(UICollectionView *)myCollerctionView
{
    if (_myCollerctionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //设置格子上左中下 间距
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //设置上下格子的间距
        flowLayout.minimumLineSpacing = 5;
        _myCollerctionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 10,MainWidth-10,self.frame.size.height-10) collectionViewLayout:flowLayout];
        //分配头部视图
        flowLayout.headerReferenceSize = CGSizeMake(MainWidth, 21);
        //注册单元格
        [_myCollerctionView registerClass:[HotWordCell class] forCellWithReuseIdentifier:@"HotWordCellID"];
        [_myCollerctionView registerNib:[UINib nibWithNibName:@"HotWordCell" bundle:nil] forCellWithReuseIdentifier:@"HotWordCellID"];
        //注册头部视图
        //UICollectionElementKindSectionHeader 表示的是此分区是头部，
        [_myCollerctionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify];
        _myCollerctionView.backgroundColor = [UIColor whiteColor];
        _myCollerctionView.dataSource = self;
        _myCollerctionView.delegate = self;
        
    }
    return _myCollerctionView;
}

@end
