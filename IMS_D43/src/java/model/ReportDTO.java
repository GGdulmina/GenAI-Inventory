package model;

import java.util.List;

/**
 * Data Transfer Object representing a report.
 * Provides a clean abstraction of report data for display or export (e.g., PDF generation).
 */
public class ReportDTO {
    private String title;
    private String type;
    private String generatedAt;
    private List<String> headers;
    private List<List<String>> rows;
    private String totalSummary;

    public ReportDTO() {}

    public ReportDTO(String title, String type, String generatedAt, List<String> headers, List<List<String>> rows, String totalSummary) {
        this.title = title;
        this.type = type;
        this.generatedAt = generatedAt;
        this.headers = headers;
        this.rows = rows;
        this.totalSummary = totalSummary;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(String generatedAt) {
        this.generatedAt = generatedAt;
    }

    public List<String> getHeaders() {
        return headers;
    }

    public void setHeaders(List<String> headers) {
        this.headers = headers;
    }

    public List<List<String>> getRows() {
        return rows;
    }

    public void setRows(List<List<String>> rows) {
        this.rows = rows;
    }

    public String getTotalSummary() {
        return totalSummary;
    }

    public void setTotalSummary(String totalSummary) {
        this.totalSummary = totalSummary;
    }
}
