package template_kotlin;

import com.exacttarget.fuelsdk.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.omnilab.micrm.common.CommonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class testSdk {


    public static void main(String[] args) throws ETSdkException {
        Logger logger = LoggerFactory.getLogger("this");

        //String btn = "{\"button\":[{\"ordering\":1,\"name\":\"사이트 방문하기\",\"linkType\":\"WL\",\"linkTypeName\":\"웹링크\",\"linkMo\":\"https://#{link}\",\"linkPc\":\"https://#{link}\",\"target\":\"out\"}]}";
        String btn = "{\"button\":[{\"ordering\":1,\"name\":\"사이트 방문하기\",\"linkType\":\"WL\",\"linkTypeName\":\"웹링크\",\"linkMo\":\"#{link}\",\"linkPc\":\"#{link}\",\"target\":\"out\"}]}";
        Gson gson = new GsonBuilder().create();
        Map<String, Object> objMap = gson.fromJson(btn, Map.class);

        Map<String, Object> keys = new HashMap<>();
        keys.put("url", "https://naver.com");
        keys.put("link", "naver.com");

        if(objMap.get("button") != null){
            var btnData = gson.toJson(objMap.get("button"));
            for (String key : keys.keySet()) {
                String patternString = "#\\{(?i)" + Pattern.quote(key) + "}";
                Pattern pattern = Pattern.compile(patternString);
                Matcher matcher = pattern.matcher(btnData);
                logger.error("matcher {}", matcher.find());
                logger.error("matcher {}", matcher.group());
                btnData = matcher.replaceAll(CommonUtils.stringValueOf(keys.get(key)));
            }
            logger.error("{}", btnData);
        }

    }
}
