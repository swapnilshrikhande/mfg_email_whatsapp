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

    public static String join(List<String> values,String separator) {
        List<String> valueCopy = new List<String>(values);
        if(valueCopy.isEmpty())
            return null;
        String result = valueCopy[0];
        valueCopy.remove(0);
        while(!valueCopy.isEmpty()) {
            result += separator + valueCopy[0];
            valueCopy.remove(0);
        }
        return result;
    }
}