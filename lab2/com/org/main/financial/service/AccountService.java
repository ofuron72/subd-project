package financial.service;

import financial.mapper.AccountMapper;
import financial.model.AccountEntity;
import financial.model.ClientEntity;
import financial.model.CurrencyEntity;
import financial.object.dto.request.CreateAccountRequest;
import financial.object.dto.response.AccountResponse;
import financial.repository.AccountRepository;
import financial.repository.ClientRepository;
import financial.repository.CurrencyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final AccountRepository accountRepository;
    private final ClientRepository clientRepository;
    private final CurrencyRepository currencyRepository;
    private final AccountMapper accountMapper;

    @Transactional
    public AccountResponse create(CreateAccountRequest request) {

        ClientEntity client = clientRepository.findById(request.getClientId())
                .orElseThrow(() -> new RuntimeException("Client not found"));

        CurrencyEntity currency = currencyRepository.findById(request.getCurrencyId())
                .orElseThrow(() -> new RuntimeException("Currency not found"));

        AccountEntity entity = accountMapper.toEntity(
                request,
                client,
                currency
        );

        AccountEntity saved = accountRepository.save(entity);

        return AccountMapper.toResponse(saved);
    }

    @Transactional(readOnly = true)
    public AccountResponse getById(Long id) {

        AccountEntity entity = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));

        return AccountMapper.toResponse(entity);
    }
}
