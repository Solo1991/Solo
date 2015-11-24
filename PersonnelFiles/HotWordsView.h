//
//  HotWordsView.h
//  PersonnelFiles
//
//  Created by Simons on 15/8/13.
//  Copyright (c) 2015年 Solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotWordsViewDelegate <NSObject>

-(void)searchWithHotWord:(NSString *)hotWord;

@end

@interface HotWordsView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *myCollerctionView;
/*热词数组*/
@property(nonatomic,strong)NSArray *hotWordArr;
@property(assign,nonatomic)CGSize hotWordsLabelSize;
@property(assign,nonatomic)id<HotWordsViewDelegate>delegate;
@end
