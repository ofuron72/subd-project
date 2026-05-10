package financial.controller;

import financial.object.dto.request.GenerateMonthlyReportRequest;
import financial.object.dto.response.MonthlyReportResponse;
import financial.service.ReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping("/generate")
    public ResponseEntity<Void> generateReport(
            @RequestBody @Valid GenerateMonthlyReportRequest request
    ) {

        reportService.generate(
                request.getPeriodFrom(),
                request.getPeriodTo()
        );

        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<List<MonthlyReportResponse>> getReports() {

        return ResponseEntity.ok(reportService.getAll());
    }
}
