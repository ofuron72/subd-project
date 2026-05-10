package financial.mapper;

import financial.model.AccountEntity;
import financial.model.ClientEntity;
import financial.model.CurrencyEntity;
import financial.object.dto.request.CreateAccountRequest;
import financial.object.dto.response.AccountResponse;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class AccountMapper {
    public AccountEntity toEntity(
            CreateAccountRequest request,
            ClientEntity client,
            CurrencyEntity currency
    ) {

        return AccountEntity.builder()
                .client(client)
                .accountNumber(request.getAccountNumber())
                .accountType(request.getAccountType())
                .currency(currency)
                .balance(BigDecimal.ZERO)
                .build();
    }

    public static AccountResponse toResponse(AccountEntity entity) {

        return AccountResponse.builder()
                .id(entity.getId())
                .accountNumber(entity.getAccountNumber())
                .accountType(entity.getAccountType())
                .balance(entity.getBalance())
                .currencyCode(entity.getCurrency().getCode())
                .clientName(entity.getClient().getFullName())
                .build();
    }
}
