LZMA_BIN := $(shell which lzma)


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_uncompressed_ramdisk) $(recovery_kernel)
	@echo -e ${PRT_IMG}"----- Compressing recovery ramdisk with lzma ------"${CL_RST}
	$(hide) $(LZMA_BIN) < $(recovery_uncompressed_ramdisk) > $(recovery_ramdisk)
	$(call build-recoveryimage-target, $@)
	@echo -e ${PRT_IMG}"----- Made recovery image: $@ --------"${CL_RST}
