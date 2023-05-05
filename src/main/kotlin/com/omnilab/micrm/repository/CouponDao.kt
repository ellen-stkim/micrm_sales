package com.omnilab.micrm.repository

import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.coupon.*
import com.omnilab.micrm.model.table.*

interface CouponDao {


    fun selectCategory(grp_cd: String): MutableList<Tblmicou_categoryDto>
    fun selectCoupon(decodedSeq: Int): CouponListDto
    fun selectCouponList(searchDto: SearchCouponDto): MutableList<CouponListDto>
    fun selectCouponListCount(searchDto: SearchCouponDto): Int
    fun selectCouponListAtSales(searchDto: SearchCouponDto): MutableList<CouponListDto>
    fun selectCouponListCountAtSales(searchDto: SearchCouponDto): Int
    fun selectCouponIssue(cont_id: String): CouponIssueDto
    fun selectCouponIssuedLogList(searchDto: SearchCouponIssuedLogDto): MutableList<CouponIssuedListDto>
    fun selectCouponIssuedLogListCount(searchDto: SearchCouponIssuedLogDto): Int
    fun selectDefaultSendNumber(dto: Tblmi_set_lstDto): String
    fun selectCouponDomain(tblmiCommCdDto: Tblmi_comm_cdDto): String
    fun selectCommCd(tblmiCommCdDto: Tblmi_comm_cdDto): Tblmi_comm_cdDto

    fun insertCoupon(dto: CouponRegisterDto)
    fun insertCouponImage(dto: Tblmicou_img_fileDto): Int
    fun insertCouponIssue(dto: Tblmicou_coupon_issueDto): Int
    fun insertCouponIssuedLog(dto: Tblmicou_coupon_issued_logDto)
    fun insertCouponIssueMsgLg(list: ArrayList<Any>): Int
    fun insertCouponIssueMsgCj(list: ArrayList<Any>): Int
    fun updateCoupon(registerDto: CouponRegisterDto)
    fun updateCouponIssueTargetCount(couponIssueSeq: Int, sendCnt: Int)

    fun deleteCoupon(deleteCouponSeq: List<Int>, usr_id: String)
    fun deleteImageFile(imageSeq: Int)
    fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<Int>, usr_id: String)
}