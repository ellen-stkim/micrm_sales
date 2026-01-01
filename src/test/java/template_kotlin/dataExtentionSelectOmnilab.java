package template_kotlin;

import com.exacttarget.fuelsdk.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Set;

public class dataExtentionSelectOmnilab {
    public static void main(String[] args) throws ETSdkException {
        Logger logger = LoggerFactory.getLogger("testSdk");

        ETConfiguration configuration = new ETConfiguration();
        configuration.set("clientId", "3k9fq4ivxzmbqjybxfnmiemk");
        configuration.set("clientSecret", "Pffpsqx9jkM0bFb77kEdGM18");
        configuration.set("authEndpoint", "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com");
        configuration.set("endpoint", "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com");
        configuration.set("soapEndpoint", "https://mcrhrh7j3bl6xd1n35nt5lxc5tk4.auth.marketingcloudapis.com/service.asmx");
        configuration.set("useOAuth2Authentication", "true");
        ETClient client = new ETClient(configuration);

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
        exp.setValue("88d24efc-b9d5-f011-a5da-5cba2c19fe48");
        etf.setExpression(exp);

//        ETClient client  = new ETClient("/fuelSdk.properties");

        logger.error("---------------------ETDataExtension------------------------");
        ETResponse<ETDataExtension> response = client.retrieve(ETDataExtension.class, "id=cce071c7-4680-ed11-ba43-5cba2c19aa40");
        ETResult<ETDataExtension> result = response.getResult();
        ETDataExtension dataExtension = result.getObject();

        ETResponse<ETDataExtensionRow> res = dataExtension.select();

        logger.error("{}", res.getObject().getColumnNames());

        logger.error("---------------------ETDataExtension------------------------");
    }
}
