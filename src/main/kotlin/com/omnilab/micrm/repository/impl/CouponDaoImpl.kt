package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.coupon.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.mdm.LgMms_msgDto
import com.omnilab.micrm.repository.CouponDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("CouponDaoImpl")
class CouponDaoImpl: CouponDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun selectCategory(grp_cd: String): MutableList<Tblmicou_categoryDto> {
        return sqlSession.selectList("select_tblmicou_category", grp_cd)
    }

    override fun selectCoupon(decodedSeq: Int): CouponListDto {
        return sqlSession.selectOne("select_coupon", decodedSeq)
    }

    override fun selectCouponList(searchDto: SearchCouponDto): MutableList<CouponListDto> {
        return sqlSession.selectList("select_coupon_list", searchDto)
    }

    override fun selectCouponListCount(searchDto: SearchCouponDto): Int {
        return sqlSession.selectOne("select_coupon_list_count", searchDto)
    }

    override fun selectCouponListAtSales(searchDto: SearchCouponDto): MutableList<CouponListDto> {
        return sqlSession.selectList("select_coupon_list_at_sales", searchDto)
    }

    override fun selectCouponListCountAtSales(searchDto: SearchCouponDto): Int {
        return sqlSession.selectOne("select_coupon_list_count_at_sales", searchDto)
    }

    override fun selectCouponIssuedLogList(searchDto: SearchCouponIssuedLogDto): MutableList<CouponIssuedListDto> {
        return sqlSession.selectList("select_coupon_issued_log_list", searchDto)
    }

    override fun selectCouponIssuedLogListCount(searchDto: SearchCouponIssuedLogDto): Int {
        return sqlSession.selectOne("select_coupon_issued_log_list_count", searchDto)
    }

    override fun selectDefaultSendNumber(dto: Tblmi_set_lstDto): String {
        return sqlSession.selectOne("select_default_send_number", dto)
    }

    override fun selectCouponDomain(tblmiCommCdDto: Tblmi_comm_cdDto): String {
        return sqlSession.selectOne("select_coupon_domain", tblmiCommCdDto)
    }

    override fun selectCommCd(tblmiCommCdDto: Tblmi_comm_cdDto): Tblmi_comm_cdDto {
        return sqlSession.selectOne("getCommCD", tblmiCommCdDto)
    }


    override fun insertCoupon(dto: CouponRegisterDto) {
        sqlSession.insert("insert_coupon", dto)
    }

    override fun insertCouponImage(dto: Tblmicou_img_fileDto): Int {
        return sqlSession.insert("insert_coupon_img", dto)
    }

    override fun insertCouponIssue(dto: Tblmicou_coupon_issueDto): Int {
        return sqlSession.insert("insert_coupon_issue", dto)
    }

    override fun insertCouponIssuedLog(dto: Tblmicou_coupon_issued_logDto) {
        sqlSession.insert("insert_coupon_issued_log", dto)
    }

    override fun insertCouponIssueMsg(dto: LgMms_msgDto): Int {
        return sqlSession.insert("insert_coupon_issue_msg", dto)
    }

    override fun updateCoupon(registerDto: CouponRegisterDto) {
        logger.info("zzz={}",registerDto.img_file_seq)
        sqlSession.update("update_coupon", registerDto)
    }

    override fun updateCouponIssueTargetCount(couponIssueSeq: Int, sendCnt: Int) {
        val map = mapOf(
            "seq" to couponIssueSeq,
            "target_cnt" to sendCnt
        )
        sqlSession.update("update_coupon_issue_target_count", map)
    }


    override fun deleteCoupon(deleteCouponSeq: List<Int>, usr_id: String) {
        val map = mapOf(
            "coupon_seq" to deleteCouponSeq,
            "upd_id" to usr_id
        )
        sqlSession.update("delete_coupon", map)
    }

    override fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<Int>, usr_id: String) {
        val map = mapOf(
            "coupon_issued_log_seq" to deleteCouponIssuedLogSeq,
            "upd_id" to usr_id
        )
        sqlSession.update("delete_coupon_issued_log", map)
    }


    override fun deleteImageFile(imageSeq: Int) {
        sqlSession.update("delete_img_file", imageSeq)
    }

}