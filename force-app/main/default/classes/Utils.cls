public class Utils {
    public static void debugMap(Map<String,Object> mapObj){
    	debugMap('',mapObj);
    }
    
    public static void debugMap(String prefix,Map<String,Object> mapObj){
        for(String key : mapObj.keySet() ) {
            System.debug(prefix+ ' : '+ key + ' => ' + String.valueOf( mapObj.get(key) ) );
        }
    }
    
    public static String sanitize(String msg){
        return String.isBlank(msg) ? '' : msg.trim().toLowerCase();
    }
    
    public static String getDateString(Integer nDaysFromToday){
        Date today = Date.today();
        Date deliveryDate = today.addDays(nDaysFromToday);
        return deliveryDate.format();
    }
}