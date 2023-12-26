public class ParkLocator {
    public static string[] country(string country){
        parksServices.parksImplPort park = new parksServices.parksImplPort();
        return park.byCountry(country);
    }
}