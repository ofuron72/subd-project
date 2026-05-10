package financial.controller;

import financial.object.dto.request.CreateAccountRequest;
import financial.object.dto.response.AccountResponse;
import financial.service.AccountService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/accounts")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    @PostMapping
    public ResponseEntity<AccountResponse> createAccount(
            @RequestBody @Valid CreateAccountRequest request
    ) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(accountService.create(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AccountResponse> getById(
            @PathVariable Long id
    ) {

        return ResponseEntity.ok(accountService.getById(id));
    }
}
