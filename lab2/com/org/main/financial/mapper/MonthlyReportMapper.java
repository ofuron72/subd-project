package financial.mapper;

import financial.model.MonthlyClientReportEntity;
import financial.object.dto.response.MonthlyReportResponse;
import org.springframework.stereotype.Component;

@Component
public class MonthlyReportMapper {

    public MonthlyReportResponse toResponse(MonthlyClientReportEntity entity) {

        return MonthlyReportResponse.builder()
                .clientName(entity.getClient().getFullName())
                .periodFrom(entity.getPeriodFrom())
                .periodTo(entity.getPeriodTo())
                .totalIncome(entity.getTotalIncome())
                .totalExpense(entity.getTotalExpense())
                .transactionCount(entity.getTransactionCount())
                .generatedAt(entity.getGeneratedAt())
                .build();
    }
}
