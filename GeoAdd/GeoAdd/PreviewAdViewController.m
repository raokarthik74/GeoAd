//
//  PreviewAdViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "PreviewAdViewController.h"

@interface PreviewAdViewController ()

@property NSMutableArray *jsonDataArray;
@property TabBarController *tabCon;

@end

@implementation PreviewAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
     [self getAdForPerson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAdForPerson{
    self.tabCon = (TabBarController*)self.tabBarController;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.tabCon.personName,@"name",nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonData %@",dic );
    NSDictionary *headers = @{ @"content-type": @"application/json" };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-user@ec2-35-165-161-51.us-west-2.compute.amazonaws.com:8080/v1/person/getpersonads"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        self.jsonDataArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:kNilOptions
                                                                                                                   error:NULL]mutableCopy];
                                                        NSLog(@"JSON data %@", self.jsonDataArray);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.tableView reloadData];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jsonDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    NSDictionary *dictObject = [self.jsonDataArray objectAtIndex:indexPath.row];
    [cell.youtubePlayer loadWithVideoId:[dictObject objectForKey:@"videourl"]];
    cell.adTitle.text = [dictObject objectForKey:@"name"];
    cell.clickRate.text = [[dictObject objectForKey:@"clickCount"] stringValue];
    cell.impressionCount.text = [[dictObject objectForKey:@"impressions"] stringValue];
    NSString *mystr= [[dictObject objectForKey:@"ctr"] stringValue];
    float ctrvalue = [mystr floatValue];
    if(ctrvalue>3){
        cell.adTitle.textColor = [UIColor greenColor];
    }
    else{
        cell.adTitle.textColor = [UIColor redColor];
    }
    cell.ctr.text = mystr;
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *dictObject = [self.jsonDataArray objectAtIndex:indexPath.row];
        [self.jsonDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.tabCon.personId,@"personId",[dictObject objectForKey:@"id"], @"adId", nil];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *headers = @{ @"content-type": @"application/json" };
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-user@ec2-35-165-161-51.us-west-2.compute.amazonaws.com:8080/v1/ad/deletead"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:jsonData];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                        }
                                                    }];
        [dataTask resume];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
