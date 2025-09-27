package com.org.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@MappedSuperclass
@Getter
@Setter
public abstract class BaseEntity {

    @Column(name = "create_dttm")
    private Instant createdAt;

    @Column(name = "modify_dttm")
    private Instant modifyAt;

    @PrePersist
    public void onCreate() {
        this.createdAt = Instant.now();
        this.modifyAt = Instant.now();
    }

    @PreUpdate
    public void onUpdate() {
        this.modifyAt = Instant.now();
    }
}


