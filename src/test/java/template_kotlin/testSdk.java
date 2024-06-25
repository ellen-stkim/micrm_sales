package template_kotlin;

import com.exacttarget.fuelsdk.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

public class testSdk {


    public static void main(String[] args) throws ETSdkException {
        Logger logger = LoggerFactory.getLogger("this");
        /*
        ETConfiguration configuration = new ETConfiguration();
        configuration.set("clientId", "a1bpjiy7elm3a5np52nb8wwu");
        configuration.set("clientSecret", "vkc6QT6ip7NYgyNVH4dRURkt");
        configuration.set("authEndpoint", "https://mcvwxvldc6v2wlp7lxxy629-j7g8.auth.marketingcloudapis.com/");
        configuration.set("endpoint", "https://mcvwxvldc6v2wlp7lxxy629-j7g8.rest.marketingcloudapis.com/");
        configuration.set("soapEndpoint", "https://mcvwxvldc6v2wlp7lxxy629-j7g8.soap.marketingcloudapis.com/");
        configuration.set("useOAuth2Authentication", "true");
        String extentionId = "88d9cf84-9de1-ee11-a5cd-5cba2c1a4d08";

        ETClient client = new ETClient(configuration);
        ETFilter filter = new ETFilter();
        ETExpression exp = new ETExpression();

        exp.setProperty("id");
        exp.setOperator(ETExpression.Operator.EQUALS);
        exp.addValue(extentionId);
        filter.setExpression(exp);

        ETResponse<ETDataExtension> response = client.retrieve(ETDataExtension.class, filter);
        logger.error("{}", response.getResult().getObject());
        */

        //logger.error("?? : {}", org.codehaus.stax2.ri.EmptyIterator.getInstance());
         //
        /*
        ETFilter etf = new ETFilter();
        etf.addProperty("id");
        etf.addProperty("key");
        etf.addProperty("name");
        etf.addProperty("description");
        etf.addProperty("folderId");
        etf.addProperty("isSendable");
        etf.addProperty("isTestable");
        ETExpression exp = new ETExpression();
        exp.setProperty("id");
        exp.setOperator("=");
        exp.setValue("7245D760-DBFA-44CB-9553-F410F1FFB538");
        etf.setExpression(exp);
        ETDataExtension productDE = client.retrieveObject(ETDataExtension.class,etf);

        System.out.println("resp="+productDE);
        */

    }
}
