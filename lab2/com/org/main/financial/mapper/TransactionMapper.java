package financial.mapper;

import financial.model.TransactionEntity;
import financial.object.dto.response.TransactionResponse;
import org.springframework.stereotype.Component;

@Component
public class TransactionMapper {

    public static TransactionResponse toResponse(TransactionEntity entity) {

        return TransactionResponse.builder()
                .id(entity.getId())
                .amount(entity.getAmount())
                .transactionType(entity.getTransactionType())
                .description(entity.getDescription())
                .createdDttm(entity.getCreateDttm())
                .build();
    }
}
