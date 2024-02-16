package template_kotlin;

import com.omnilab.micrm.common.CommonUtils;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class testtest {

    public static void main(String[] args) {
        Logger logger = LoggerFactory.getLogger("testtest");

        // admin@hankyung.com
        // logger.error("{}", CommonUtils.sha512("hankyung_20230926_#@"));
        // logger.error("{}", CommonUtils.sha512("daewonmedia_20231123_#@"));



        PaginationInfo pagination = new PaginationInfo();
        pagination.setCurrentPageNo(1);
        pagination.setPageSize(10);
        pagination.setRecordCountPerPage(10);
        pagination.setTotalRecordCount(1000);

        logger.error("{}", pagination.getFirstRecordIndex());
        logger.error("{}", pagination.getTotalPageCount());
        logger.error("{}", pagination.getLastPageNoOnPageList());
        logger.error("{}", pagination.getLastRecordIndex());
        logger.error("{}", pagination.getLastPageNo());
    }

}
