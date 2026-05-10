package financial.controller;

import financial.service.InterestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final InterestService interestService;

    @PostMapping("/interest/apply")
    public ResponseEntity<Void> applyInterest() {

        interestService.applyInterest();

        return ResponseEntity.ok().build();
    }
}
