package financial.object.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MonthlyReportResponse {

    private String clientName;

    private LocalDate periodFrom;

    private LocalDate periodTo;

    private BigDecimal totalIncome;

    private BigDecimal totalExpense;

    private Long transactionCount;

    private OffsetDateTime generatedAt;
}
