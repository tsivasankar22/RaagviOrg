@isTest
private class ParkLocatorTest {
    @isTest static void testCallout(){
        
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        string country = 'United States';
        List<string> result = ParkLocator.country(country);
        List<string> parks = new List<string>{'Yellowstone','Mackinac National Park','Yosemite'};
        system.assertEquals(parks, result);
    }

}