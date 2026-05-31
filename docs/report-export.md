# Report PDF Export Feature — Technical Documentation

This document describes the design, architecture, and implementation details of the PDF export feature for the Reports module in the GenAI-Inventory Management System.

---

## 1. Feature Overview

The PDF Export feature enables users to download a beautifully formatted, print-ready PDF version of any selected report:
- **Daily Sales Report:** Displays invoices, sale timestamps, total amounts, and creator usernames for a specific day.
- **Monthly Sales Report:** Aggregates transactions and total revenue day-by-day for a selected month.
- **Stock Report:** Details product inventory, including category, quantity, total stock valuation, and stock level status flags (`LOW`, `OK`, `OVER`).

---

## 2. Architecture & Design

The implementation adheres strictly to the **Model-View-Controller (MVC)** and **Three-Tier Architecture** patterns, ensuring a clean separation of concerns:

```
    +-----------------------+
    |   reports.jsp (View)  |
    +-----------+-----------+
                |
                | (action=downloadPdf)
                v
    +-----------------------+
    | ReportServlet (Ctrl)  |
    +-----------+-----------+
                |
                | (getReportDTO)
                v
    +-----------------------+
    |  ReportService (Serv) |
    +-----+-----------+-----+
          |           |
          |           | (create PDF)
          v           v
    +-----+----+ +----+----------------+
    |ReportDAO | |PdfReportGenerator |
    +-----+----+ +-----------+--------+
          |                  |
          v                  | (binary write)
    +-----+----+             v
    | Database |      +------+------+
    +----------+      | User Browser|
                      +-------------+
```

### Components and Responsibilities

1. **Controller Layer (`Servlet.ReportServlet`):**
   - Intercepts requests to `/reports`.
   - Validates session state (authentication).
   - Routes request to PDF generation when `action=downloadPdf` is specified.
   - Sets appropriate HTTP response headers (MIME type, content disposition attachment).
   - Opens binary streams and delegates writing.

2. **Service Layer (`service.ReportService`):**
   - Retrieves raw query structures from the DAO.
   - Implements validation rules (e.g. non-empty parameters, valid report type).
   - Translates database-agnostic lists of maps into an layout-oriented DTO.
   - Formats currency (`$#,##0.00`) and timestamps (`yyyy-MM-dd HH:mm`).
   - Computes report metrics (total revenue, product item counts).

3. **Model Layer (`model.ReportDTO`):**
   - Plain Old Java Object (POJO) encapsulating structured report metadata.
   - Decoupled from JDBC/DAO data concepts, defining table grids (Headers, Rows, Title, Summary) which makes the PDF Generator generic and easily extensible.

4. **Utility Layer (`util.PdfReportGenerator`):**
   - Uses the iText engine to format and draw document layout.
   - Renders a top corporate header, zebra-striped tables, right-aligned numbers, and custom status badge styling.
   - Implements dynamic page numbering in the format `"Page X of Y"`.

5. **JSP Layer (`reports.jsp`):**
   - Displays records on-screen.
   - Triggers the PDF download by linking to `/reports` with the active search criteria query parameters.
   - Contains NO business logic, SQL statements, or PDF rendering code.

---

## 3. API Endpoints

The feature is integrated into the existing `/reports` servlet route:

| HTTP Method | Endpoint | Query Parameters | Description |
| :--- | :--- | :--- | :--- |
| **GET** | `/reports` | `action=downloadPdf`<br>`type=daily`<br>`date=yyyy-MM-dd` | Downloads the Daily Sales Report for the selected date. |
| **GET** | `/reports` | `action=downloadPdf`<br>`type=monthly`<br>`month=yyyy-MM` | Downloads the Monthly Sales Report for the selected month. |
| **GET** | `/reports` | `action=downloadPdf`<br>`type=stock` | Downloads the active Inventory Stock Status Report. |

---

## 4. How PDF Generation Works

PDF writing is handled via the standalone utility `util.PdfReportGenerator`. The generation lifecycle involves:

1. **Document Setup:** Instantiates an A4 document with 36pt margins.
2. **Page Event Handling:** Attaches a `HeaderFooterPageEvent` implementing `onEndPage()` to draw a thin divider line and a footer displaying page counts. It uses a `PdfTemplate` template block written on document closure to calculate total page count dynamically.
3. **Header Construction:** Builds a two-column layout showing the system identifier on the left and the specific report meta info on the right.
4. **Decorative Accents:** Adds a purple divider line (thickness: 2f, color: `#7c5cfc`) separating header from content.
5. **Table Assembly:** Creates a `PdfPTable` with specific column percentage sizes matching the report type. Headers are styled with purple background and white text.
6. **Data Cells & Alignments:**
   - Text cells left-align; numeric values (Total, Qty, Revenue) right-align.
   - Alternating odd rows receive a zebra light gray shading (`#f5f5fa`).
   - Badges (LOW, OK, OVER) receive custom background and text styling (e.g. LOW is filled with light red and dark red text).
   - Empty reports output a centered block displaying *"No data available for this period."*
7. **Total Summary Block:** Appends a left-bordered callout box listing calculation metrics at the bottom of the table.

---

## 5. Dependencies Used

- **iText 2.1.7 (`web/WEB-INF/lib/itext-2.1.7.jar`):**
  - Lightweight, LGPL/MPL-licensed PDF generation library.
  - Zero external run-time dependencies.
  - Placed inside `WEB-INF/lib` to be automatically bundled inside the WAR distribution.

---

## 6. Error and Edge Case Handling

1. **Empty Datasets:**
   - If there is no sales information for a day/month, the PDF handles it gracefully by writing a clean note centered on the grid rather than throwing a `NullPointerException` or building a broken table.
2. **Data Type Conversions:**
   - Protects against unexpected database values by converting values safely inside `ReportService` using standard number converters and string fallback methods.
3. **Exception Boundary:**
   - Any query or drawing failure is caught before the response header is written, allowing the container to throw a normal servlet exception, preventing the generation of corrupted PDF files.
4. **Stream Management:**
   - Utilizes `try-with-resources` block on `response.getOutputStream()` to ensure binary handlers are closed properly, avoiding system memory leaks.

---

## 7. Known Limitations & Future Improvements

- **Limitations:**
  - Standard PDF outputs are sized for A4 portrait layouts. Extremely wide reports might require landscape resizing in the future.
  - Relies on system-default Helvetica fonts.
- **Future Improvements:**
  - Support landscape orientation configuration in the servlet.
  - Support additional formats such as CSV/Excel exports using Apache POI.
  - Embed mini-charts dynamically in the document.
