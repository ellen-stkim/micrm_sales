package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.coupon.CouponListDto
import com.omnilab.micrm.model.coupon.SearchCouponDto
import com.omnilab.micrm.model.coupon.SearchCouponIssuedLogDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.repository.CouponDao
import com.omnilab.micrm.service.CouponListService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class CouponListServiceImpl: CouponListService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var couponDao: CouponDao

    override fun getCouponList(searchDto: SearchCouponDto): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(searchDto.pageNo,10,10)

        // 쿠폰 리스트 조회
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        val couponList = couponDao.selectCouponList(searchDto)

        // 시퀀스 AES256 암호화 (couponListDto.encodedSeq에 암호화된 seq 저장)
        couponList.forEach {
            it.encodedSeq = encodingSeq(it.seq!!)
        }

        // 페이징 설정
        paginationInfo.totalRecordCount = couponDao.selectCouponListCount(searchDto)
        setPagination(reMap, paginationInfo)

        reMap["list"] = couponList
        return reMap
    }

    override fun getCouponListAtSales(searchDto: SearchCouponDto, usr_grp_cd: String): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(searchDto.pageNo,10,10)

        // 쿠폰 리스트 조회
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        searchDto.usr_grp_cd = usr_grp_cd
        val couponList = couponDao.selectCouponListAtSales(searchDto)

        // 시퀀스 AES256 암호화 (couponListDto.encodedSeq에 암호화된 seq 저장)
        couponList.forEach {
            it.encodedSeq = encodingSeq(it.seq!!)
        }

        // 페이징 설정
        paginationInfo.totalRecordCount = couponDao.selectCouponListCountAtSales(searchDto)
        setPagination(reMap, paginationInfo)

        reMap["list"] = couponList
        return reMap
    }

    override fun getCoupon(encodedSeq: String): CouponListDto {
        val findCoupon = couponDao.selectCoupon(decodingSeq(encodedSeq))
        findCoupon.encodedSeq = encodingSeq(findCoupon.seq!!)

        return findCoupon
    }

    override fun getCouponIssuedLogList(searchDto: SearchCouponIssuedLogDto): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()
        val paginationInfo : PaginationInfo = UsefulUtils.makePage(searchDto.pageNo,10,10)

        // 쿠폰 발급 내역 리스트 조회
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        val couponIssuedLogList = couponDao.selectCouponIssuedLogList(searchDto)

        // 시퀀스 암호화
        couponIssuedLogList.forEach {
            it.encodedSeq = encodingSeq(it.seq!!.toInt())
        }

        // 페이징
        paginationInfo.totalRecordCount = couponDao.selectCouponIssuedLogListCount(searchDto)
        setPagination(reMap, paginationInfo)

        reMap["list"] = couponIssuedLogList
        return reMap
    }

    override fun getDefaultSendNumber(): String {

        val searchDto = Tblmi_set_lstDto()
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.list_tp_id = "CH02"
        searchDto.list_dt_id = "DMTP02"

        return couponDao.selectDefaultSendNumber(searchDto)
    }

    private fun decodingSeq(encodedSeq: String) = AES256.AES_Decode(encodedSeq, GlobalValues.encKey).toInt()

    private fun encodingSeq(seq: Int) = AES256.AES_Encode(seq.toString(), GlobalValues.encKey)

    private fun setPagination(reMap: MutableMap<String, Any>, paginationInfo: PaginationInfo) {
        reMap["page"] = paginationInfo
        reMap["pageNo"] = paginationInfo.currentPageNo
        reMap["cnt"] = paginationInfo.totalRecordCount
    }

}