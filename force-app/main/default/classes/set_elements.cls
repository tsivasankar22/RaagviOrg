public class set_elements {
    public static void add(){
        List<String> l1=new List<String>();
        List<Integer> l2=new List<Integer>();
        set<Integer> l3=new Set<Integer>();
        
        
        l1.add('SHiva');
        l1.add('Shankar');
        l2.add(19);
        l2.add(32);
        l1.set(1,'SS');
        l3.add(10);
        l3.add(20);
        l3.remove(10);
        System.debug(l1);
        System.debug(l2);
        System.debug(l1.size());
        System.debug(l1.get(1)); 
        System.debug(l3.size());
        System.debug(l3);
    }
    

}