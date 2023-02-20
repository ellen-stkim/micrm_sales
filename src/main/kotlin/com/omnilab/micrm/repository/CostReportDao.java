package com.omnilab.micrm.repository;

import com.omnilab.micrm.model.SearchSendCostDto;
import com.omnilab.micrm.model.SendCostDto;
import org.jetbrains.annotations.NotNull;

import java.util.List;

public interface CostReportDao {

    List<SendCostDto> selSendCostLst(SendCostDto hstDto);

    List<SendCostDto> selPrgSendCostLst(SendCostDto hstDto);

    int selPrgSendCostLstCnt(SearchSendCostDto searchDto);
}
