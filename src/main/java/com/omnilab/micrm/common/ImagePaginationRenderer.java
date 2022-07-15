package com.omnilab.micrm.common;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class ImagePaginationRenderer extends AbstractPaginationRenderer {
	
	public ImagePaginationRenderer() {
		firstPageLabel = "<li class=\"first active\" onclick=\"{0}({1}); return false;\"></li>";
        previousPageLabel = "<li class=\"prev active\" onclick=\"{0}({1}); return false;\"></li>";
        currentPageLabel = "<li class=\"page on\">{0}</li>";
        otherPageLabel = "<li class=\"page\" onclick=\"{0}({1}); return false;\">{2}</li>";
        nextPageLabel = "<li class=\"next active\" onclick=\"{0}({1}); return false;\"></li>";
        lastPageLabel = "<li class=\"last active\" onclick=\"{0}({1}); return false;\"></li>";
    }
}
