package template_kotlin;

import com.exacttarget.fuelsdk.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class testSdk {


    public static void main(String[] args) throws ETSdkException {
        Logger logger = LoggerFactory.getLogger("this");

        ETConfiguration configuration = new ETConfiguration();
        configuration.set("clientId", "jhivti6zdgxeo5l7stp469pk");
        configuration.set("clientSecret", "gouyx2j369y0qqEAWkJICllp");
        configuration.set("authEndpoint", "https://mcrv-yxmjfh7819-z8r-sry7vgq4.auth.marketingcloudapis.com");
        configuration.set("endpoint", "https://mcrv-yxmjfh7819-z8r-sry7vgq4.rest.marketingcloudapis.com");
        configuration.set("soapEndpoint", "https://mcrv-yxmjfh7819-z8r-sry7vgq4.soap.marketingcloudapis.com/service.asmx");
        configuration.set("useOAuth2Authentication", "true");
        ETClient client = new ETClient(configuration);

        logger.error("?? : {}", org.codehaus.stax2.ri.EmptyIterator.getInstance());

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

        //ETResponse<ETDataExtension> response = client.retrieve(ETDataExtension.class, etf);

        ETDataExtension productDE = client.retrieveObject(ETDataExtension.class,etf);

        System.out.println("resp="+productDE);

    }
}
