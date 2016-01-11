//
//  RealmRadarChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "RealmRadarChartViewController.h"
#import "ChartsDemo-Swift.h"
#import <Realm/Realm.h>
#import "RealmDemoData.h"

@interface RealmRadarChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet RadarChartView *chartView;

@end

@implementation RealmRadarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self writeRandomDataToDbWithObjectCount:7];
    
    self.title = @"Realm.io Pie Chart Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleXLabels", @"label": @"Toggle X-Values"},
                     @{@"key": @"toggleYLabels", @"label": @"Toggle Y-Values"},
                     @{@"key": @"toggleRotate", @"label": @"Toggle Rotate"},
                     @{@"key": @"toggleFill", @"label": @"Toggle Fill"},
                     @{@"key": @"spin", @"label": @"Spin"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"}
                     ];
    
    [self setupRadarChartView:_chartView];
    
    _chartView.yAxis.enabled = NO;
    _chartView.webAlpha = 0.7f;
    _chartView.innerWebColor = UIColor.darkGrayColor;
    _chartView.webColor = UIColor.grayColor;

    _chartView.delegate = self;
    
    [self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData
{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *results = [RealmDemoData allObjectsInRealm:realm];
    
    // RealmRadarDataSet *set = [[RealmRadarDataSet alloc] initWithResults:results yValueField:@"stackValues" xIndexField:@"xIndex"]; // normal entries
    RealmRadarDataSet *set = [[RealmRadarDataSet alloc] initWithResults:results yValueField:@"value" xIndexField:@"xIndex"]; // stacked entries
    
    set.label = @"Realm RadarDataSet";
    set.drawFilledEnabled = YES;
    [set setColor:[ChartColorTemplates colorFromString:@"#009688"]];
    [set setFillColor:[ChartColorTemplates colorFromString:@"#009688"]];
    set.fillAlpha = 0.5f;
    set.lineWidth = 2.f;
    
    NSArray<RealmRadarDataSet *> *dataSets = @[set];

    RadarChartData *data = [[RadarChartData alloc] initWithXVals:@[@"2013", @"2014", @"2015", @"2016", @"2017", @"2018", @"2019"] dataSets:dataSets];

    [data loadXValuesFromRealmResults:results xValueField:@"xValue"];
    [self styleData:data];
    
    _chartView.data = data;
    [_chartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleXLabels"])
    {
        _chartView.xAxis.drawLabelsEnabled = !_chartView.xAxis.isDrawLabelsEnabled;
        
        [_chartView notifyDataSetChanged];
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleYLabels"])
    {
        _chartView.yAxis.drawLabelsEnabled = !_chartView.yAxis.isDrawLabelsEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleRotate"])
    {
        _chartView.rotationEnabled = !_chartView.isRotationEnabled;
    }
    
    if ([key isEqualToString:@"toggleFill"])
    {
        for (RadarChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"spin"])
    {
        [_chartView spinWithDuration:2.0 fromAngle:_chartView.rotationAngle toAngle:_chartView.rotationAngle + 360.f easingOption:ChartEasingOptionEaseInCubic];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
