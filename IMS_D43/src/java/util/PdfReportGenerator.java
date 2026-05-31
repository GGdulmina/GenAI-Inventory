package util;

import model.ReportDTO;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.awt.Color;
import java.io.OutputStream;
import java.util.List;

/**
 * Utility class for generating beautifully formatted, professional PDF reports
 * using the iText library.
 */
public class PdfReportGenerator {

    // Theme Colors
    private static final Color COLOR_PRIMARY = new Color(124, 92, 252);     // Purple
    private static final Color COLOR_SECONDARY = new Color(22, 27, 34);     // Dark charcoal
    private static final Color COLOR_TEXT_LIGHT = new Color(120, 120, 120); // Gray
    private static final Color COLOR_ZEBRA = new Color(245, 245, 250);       // Very light purple-gray
    private static final Color COLOR_BORDER = new Color(220, 220, 225);      // Border color

    // Status Badge Colors
    private static final Color BG_STATUS_LOW = new Color(254, 226, 226);    // Light Red
    private static final Color FG_STATUS_LOW = new Color(220, 38, 38);      // Dark Red
    
    private static final Color BG_STATUS_OK = new Color(220, 252, 231);     // Light Green
    private static final Color FG_STATUS_OK = new Color(22, 163, 74);       // Dark Green

    private static final Color BG_STATUS_OVER = new Color(254, 243, 199);   // Light Yellow/Orange
    private static final Color FG_STATUS_OVER = new Color(217, 119, 6);     // Dark Yellow/Orange

    /**
     * Generates a PDF report and writes it to the provided output stream.
     *
     * @param report     The ReportDTO containing the data.
     * @param outStream  The output stream to write the PDF bytes to.
     * @throws DocumentException If a PDF writing error occurs.
     */
    public static void generateReportPdf(ReportDTO report, OutputStream outStream) throws DocumentException {
        // Create Document with A4 size and margins
        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, outStream);

        // Add header/footer page events for page numbers and footer info
        HeaderFooterPageEvent event = new HeaderFooterPageEvent();
        writer.setPageEvent(event);

        document.open();

        // 1. Title Banner/Header Table
        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingBefore(10f);
        headerTable.setSpacingAfter(10f);
        headerTable.setWidths(new float[]{60f, 40f});

        // Left side: Brand
        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        Paragraph brand = new Paragraph("GenAI-Inventory", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Font.BOLD, COLOR_PRIMARY));
        Paragraph subtitle = new Paragraph("Inventory & Sales Intelligence", FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, COLOR_TEXT_LIGHT));
        leftCell.addElement(brand);
        leftCell.addElement(subtitle);
        headerTable.addCell(leftCell);

        // Right side: Metadata
        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        
        Paragraph docTitle = new Paragraph(report.getTitle(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, Font.BOLD, COLOR_SECONDARY));
        docTitle.setAlignment(Element.ALIGN_RIGHT);
        
        Paragraph docMeta = new Paragraph("Generated: " + report.getGeneratedAt(), FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, COLOR_TEXT_LIGHT));
        docMeta.setAlignment(Element.ALIGN_RIGHT);
        
        rightCell.addElement(docTitle);
        rightCell.addElement(docMeta);
        headerTable.addCell(rightCell);

        document.add(headerTable);

        // 2. Purple Decorative Horizontal Line
        PdfPTable lineTable = new PdfPTable(1);
        lineTable.setWidthPercentage(100);
        lineTable.setSpacingAfter(20f);
        PdfPCell lineCell = new PdfPCell();
        lineCell.setBorder(Rectangle.BOTTOM);
        lineCell.setBorderWidthBottom(2f);
        lineCell.setBorderColorBottom(COLOR_PRIMARY);
        lineCell.setPadding(0);
        lineTable.addCell(lineCell);
        document.add(lineTable);

        // 3. Report Data Table
        List<String> headers = report.getHeaders();
        List<List<String>> rows = report.getRows();

        if (headers == null || headers.isEmpty()) {
            document.add(new Paragraph("No headers defined for this report.", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Color.RED)));
            document.close();
            return;
        }

        PdfPTable dataTable = new PdfPTable(headers.size());
        dataTable.setWidthPercentage(100);
        dataTable.setSpacingBefore(10f);
        dataTable.setSpacingAfter(15f);
        dataTable.setSplitRows(true);
        dataTable.setKeepTogether(false);

        // Adjust column widths based on report type
        try {
            float[] widths = getColumnWidths(report.getType(), headers.size());
            dataTable.setWidths(widths);
        } catch (Exception e) {
            // Fallback to equal widths if any error occurs
        }

        // Add Headers
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Font.BOLD, Color.WHITE);
        for (String colHeader : headers) {
            PdfPCell cell = new PdfPCell(new Paragraph(colHeader, headerFont));
            cell.setBackgroundColor(COLOR_PRIMARY);
            cell.setBorder(Rectangle.BOX);
            cell.setBorderColor(COLOR_PRIMARY);
            cell.setPadding(6f);
            cell.setHorizontalAlignment(getHeaderAlignment(colHeader));
            dataTable.addCell(cell);
        }

        // Add Data Rows
        Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, COLOR_SECONDARY);
        Font statusFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, Font.BOLD);
        
        if (rows == null || rows.isEmpty()) {
            // Handle Empty Dataset
            PdfPCell emptyCell = new PdfPCell(new Paragraph("No data available for this period.", FontFactory.getFont(FontFactory.HELVETICA, 9, Font.ITALIC, COLOR_TEXT_LIGHT)));
            emptyCell.setColspan(headers.size());
            emptyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            emptyCell.setPadding(15f);
            emptyCell.setBorderColor(COLOR_BORDER);
            dataTable.addCell(emptyCell);
        } else {
            int rowIndex = 0;
            for (List<String> rowData : rows) {
                Color rowBg = (rowIndex % 2 == 1) ? COLOR_ZEBRA : Color.WHITE;
                
                for (int colIndex = 0; colIndex < rowData.size(); colIndex++) {
                    String value = rowData.get(colIndex);
                    String headerName = headers.get(colIndex);
                    
                    PdfPCell cell;
                    
                    // Specific highlight styling for Stock Status
                    if ("Status".equalsIgnoreCase(headerName)) {
                        cell = createStatusBadgeCell(value, statusFont, rowBg);
                    } else {
                        Paragraph cellText = new Paragraph(value, bodyFont);
                        cell = new PdfPCell(cellText);
                        cell.setBackgroundColor(rowBg);
                        cell.setPadding(6f);
                        cell.setBorderColor(COLOR_BORDER);
                        cell.setHorizontalAlignment(getCellAlignment(headerName));
                    }
                    
                    dataTable.addCell(cell);
                }
                rowIndex++;
            }
        }

        document.add(dataTable);

        // 4. Total Summary Callout Block
        if (report.getTotalSummary() != null && !report.getTotalSummary().trim().isEmpty()) {
            PdfPTable summaryTable = new PdfPTable(1);
            summaryTable.setWidthPercentage(100);
            summaryTable.setSpacingBefore(10f);
            
            PdfPCell sumCell = new PdfPCell();
            sumCell.setPadding(10f);
            sumCell.setBackgroundColor(COLOR_ZEBRA);
            sumCell.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
            sumCell.setBorderWidthLeft(3f);
            sumCell.setBorderColorLeft(COLOR_PRIMARY);
            sumCell.setBorderColorTop(COLOR_BORDER);
            sumCell.setBorderColorBottom(COLOR_BORDER);
            sumCell.setBorderColorRight(COLOR_BORDER);
            
            Paragraph sumText = new Paragraph(report.getTotalSummary(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD, COLOR_SECONDARY));
            sumCell.addElement(sumText);
            summaryTable.addCell(sumCell);
            
            document.add(summaryTable);
        }

        document.close();
    }

    /**
     * Determines column widths based on report type.
     */
    private static float[] getColumnWidths(String type, int numCols) {
        if ("DAILY".equalsIgnoreCase(type)) {
            return new float[]{20f, 35f, 25f, 20f}; // Invoice, Date, Total, User
        } else if ("MONTHLY".equalsIgnoreCase(type)) {
            return new float[]{40f, 30f, 30f};     // Day, Transaction Count, Revenue
        } else if ("STOCK".equalsIgnoreCase(type)) {
            return new float[]{35f, 20f, 15f, 15f, 15f}; // Product, Category, Qty, Value, Status
        }
        
        // Equal widths fallback
        float[] widths = new float[numCols];
        for (int i = 0; i < numCols; i++) widths[i] = 100f / numCols;
        return widths;
    }

    /**
     * Determines alignment for header cell text.
     */
    private static int getHeaderAlignment(String colHeader) {
        if (colHeader == null) return Element.ALIGN_LEFT;
        
        switch (colHeader.trim()) {
            case "Total":
            case "Revenue":
            case "Transaction Count":
            case "Quantity":
            case "Stock Value":
            case "Qty":
            case "Value":
                return Element.ALIGN_RIGHT;
            case "Status":
                return Element.ALIGN_CENTER;
            default:
                return Element.ALIGN_LEFT;
        }
    }

    /**
     * Determines alignment for body cell text based on column header.
     */
    private static int getCellAlignment(String colHeader) {
        return getHeaderAlignment(colHeader);
    }

    /**
     * Helper to render custom styled status badge cells (LOW/OK/OVER).
     */
    private static PdfPCell createStatusBadgeCell(String status, Font font, Color defaultBg) {
        PdfPCell cell = new PdfPCell();
        cell.setPadding(6f);
        cell.setBorderColor(COLOR_BORDER);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        Paragraph p = new Paragraph(status, font);
        p.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(p);

        if ("LOW".equalsIgnoreCase(status)) {
            cell.setBackgroundColor(BG_STATUS_LOW);
            font.setColor(FG_STATUS_LOW);
        } else if ("OK".equalsIgnoreCase(status)) {
            cell.setBackgroundColor(BG_STATUS_OK);
            font.setColor(FG_STATUS_OK);
        } else if ("OVER".equalsIgnoreCase(status)) {
            cell.setBackgroundColor(BG_STATUS_OVER);
            font.setColor(FG_STATUS_OVER);
        } else {
            cell.setBackgroundColor(defaultBg);
            font.setColor(COLOR_SECONDARY);
        }

        return cell;
    }

    /**
     * Inner class implementing page event helper to format headers/footers and handle page numbering.
     */
    private static class HeaderFooterPageEvent extends PdfPageEventHelper {
        private PdfTemplate totalPagesTemplate;
        private BaseFont helveticaFont;

        @Override
        public void onOpenDocument(PdfWriter writer, Document document) {
            totalPagesTemplate = writer.getDirectContent().createTemplate(30, 16);
            try {
                helveticaFont = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
            } catch (Exception e) {
                // Fail-safe font loading
            }
        }

        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfContentByte cb = writer.getDirectContent();
            cb.saveState();

            // 1. Thin gray footer divider line
            cb.setColorStroke(new Color(210, 210, 215));
            cb.setLineWidth(0.5f);
            cb.moveTo(document.left(), document.bottom() - 10);
            cb.lineTo(document.right(), document.bottom() - 10);
            cb.stroke();

            // 2. Footer text setup
            cb.beginText();
            cb.setFontAndSize(helveticaFont, 7.5f);
            cb.setColorFill(COLOR_TEXT_LIGHT);

            // Left Side: Disclaimer/Brand
            cb.showTextAligned(PdfContentByte.ALIGN_LEFT, "GenAI-Inventory Report | Confidential", document.left(), document.bottom() - 22, 0);

            // Right Side: Page X of Y (Template trick)
            String pageText = "Page " + writer.getPageNumber() + " of ";
            float textLength = helveticaFont.getWidthPoint(pageText, 7.5f);
            cb.showTextAligned(PdfContentByte.ALIGN_RIGHT, pageText, document.right() - totalPagesTemplate.getWidth(), document.bottom() - 22, 0);
            cb.endText();

            // Place the template representing total pages
            cb.addTemplate(totalPagesTemplate, document.right() - totalPagesTemplate.getWidth(), document.bottom() - 22);
            
            cb.restoreState();
        }

        @Override
        public void onCloseDocument(PdfWriter writer, Document document) {
            // Write total number of pages into the template at closing
            totalPagesTemplate.beginText();
            totalPagesTemplate.setFontAndSize(helveticaFont, 7.5f);
            totalPagesTemplate.setColorFill(COLOR_TEXT_LIGHT);
            totalPagesTemplate.showText(String.valueOf(writer.getPageNumber() - 1));
            totalPagesTemplate.endText();
        }
    }
}
