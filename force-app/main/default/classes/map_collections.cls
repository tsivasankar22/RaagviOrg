public class map_collections {
    public static void addmap(){
        map<Integer,String> m= new map<Integer,String>();
        m.put(1,'sankar');
        m.put(2,'raagvitech');
        m.put(3,'raagvi');
        m.put(1,'SS');
        System.debug(m);
        System.debug(m.get(1));
        System.debug(m.size());
        System.debug(m.remove(1));
        
    }

}