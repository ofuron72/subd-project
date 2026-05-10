package financial.controller;

import financial.object.dto.request.TransferRequest;
import financial.service.TransferService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/transfers")
@RequiredArgsConstructor
public class TransferController {

    private final TransferService transferService;

    @PostMapping
    public ResponseEntity<Void> transfer(
            @RequestBody @Valid TransferRequest request
    ) {

        transferService.transfer(
                request.getFromAccountId(),
                request.getToAccountId(),
                request.getAmount()
        );

        return ResponseEntity.ok().build();
    }
}
