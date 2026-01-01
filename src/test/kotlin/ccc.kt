import org.apache.poi.ss.usermodel.*
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.streaming.SXSSFWorkbook
import org.slf4j.LoggerFactory
import java.io.FileOutputStream
import kotlin.math.log

class ccc {
}

fun main() {
    val logger = LoggerFactory.getLogger("ccc")

    val sendTypes = listOf("알림톡", "브랜드톡(txt)", "브랜드톡(img)", "브랜드톡(wid)", "SMS", "LMS", "MMS", "RCS SMS", "RCS LMS", "RCS MMS", "RCS 템플릿")

    val workbook: Workbook = SXSSFWorkbook(1000)
    val sheet = workbook.createSheet("Report")

    val centerStyle = workbook.createCellStyle().apply {
        alignment = HorizontalAlignment.CENTER
        verticalAlignment = VerticalAlignment.CENTER
    }

    // Header row 1
    var rowIdx = 0
    val header1 = sheet.createRow(rowIdx++)
    header1.createCell(0).apply {
        setCellValue("캠페인명")
        cellStyle = centerStyle
    }
    header1.createCell(1).apply {
        setCellValue("시작일시")
        cellStyle = centerStyle
    }
    header1.createCell(2).apply {
        setCellValue("발송건수")
        cellStyle = centerStyle
    }
    header1.createCell(2 + sendTypes.size).apply {
        setCellValue("발송비용")
        cellStyle = centerStyle
    }

    // Merge headers
    sheet.addMergedRegion(CellRangeAddress(0, 1, 0, 0)) // 캠페인명
    sheet.addMergedRegion(CellRangeAddress(0, 1, 1, 1)) // 시작일시
    sheet.addMergedRegion(CellRangeAddress(0, 0, 2, 2 + sendTypes.size - 1)) // 발송건수
    sheet.addMergedRegion(CellRangeAddress(0, 0, 2 + sendTypes.size, 2 + 2 * sendTypes.size - 1)) // 발송비용

    // Header row 2
    val header2 = sheet.createRow(rowIdx++)
    for ((i, label) in sendTypes.withIndex()) {
       header2.createCell(2 + i).apply {
           setCellValue(label)
           cellStyle = centerStyle
       }
       header2.createCell(2 + sendTypes.size + i).apply {
           setCellValue(label)
           cellStyle = centerStyle
       }
    }

    val data = listOf(
        Triple("mst 이동 변경테스트22", "2023-03-17 12:48", List(11) { it + 1 } to List(11) { if (it < 3) 3 - it else 0 }),
        Triple("세일즈포스테스트", "2023-03-22 17:22", List(11) { it + 1 } to List(11) { if (it < 3) 3 - it else 0 }),
        Triple("세일즈포스테스트", "2023-03-23 13:28", List(11) { it + 1 } to List(11) { if (it < 3) 3 - it else 0 }),
    )

    for ((campaign, date, pair) in data) {
        val row = sheet.createRow(rowIdx++)
        logger.error("rowNum {}", row.rowNum)
        row.createCell(0).setCellValue(campaign)
        row.createCell(1).setCellValue(date)
        pair.first.forEachIndexed { i, v -> row.createCell(2 + i).setCellValue(v.toDouble()) }
        pair.second.forEachIndexed { i, v -> row.createCell(2 + sendTypes.size + i).setCellValue(v.toDouble()) }
    }
    FileOutputStream("C:\\Users\\milvus_lucas\\Downloads\\aa.xlsx").use {
        workbook.write(it)
    }
    workbook.close()
}