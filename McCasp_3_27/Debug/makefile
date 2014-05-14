################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccsv5/tools/compiler/c6000_7.4.4

ORDERED_OBJS += \
$(GEN_CMDS__FLAG) \
"./mcaspPlayBk.obj" \
"./fftstuff.obj" \
"./codecif.obj" \
"./aic31.obj" \
"../mcaspPlayBk.cmd" \
-ldrivers.lib \
-l"C:\Program Files\Texas Instruments\c674x-dsplib_1_03_00_01\lib\dsplib674x_elf.lib" \
-lutils.lib \
-lplatform.lib \
-lsystem_config.lib \
-l"libc.a" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: McCasp_3_27.out

# Tool invocations
McCasp_3_27.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: $@'
	@echo 'Invoking: C6000 Linker'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.4/bin/cl6x" -mv6740 --abi=eabi -g --define=c6748 --display_error_number --diag_warning=225 --diag_wrap=off -z --stack_size=0x800 -m"McCasp_3_27.map" --heap_size=0x800 -i"C:/ti/ccsv5/tools/compiler/c6000_7.4.4/include" -i"C:/ti/ccsv5/tools/compiler/c6000_7.4.4/lib" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/c6748/drivers/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/c6748/lcdkC6748/platform/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/c6748/system_config/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/c6748/ipclib/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/c6748/usblib/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/utils/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/grlib/Debug" -i"C:/Program Files/Texas Instruments/pdk_C6748_2_0_0_0/C6748_StarterWare_1_20_03_03/binary/c674x/cgt_ccs/nandlib/Debug" --reread_libs --warn_sections --display_error_number --diag_wrap=off --xml_link_info="McCasp_3_27_linkInfo.xml" --rom_model -o "McCasp_3_27.out" $(ORDERED_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(C6000_EXECUTABLE_OUTPUTS__QUOTED) "McCasp_3_27.out"
	-$(RM) "aic31.pp" "codecif.pp" "fftstuff.pp" "mcaspPlayBk.pp" 
	-$(RM) "aic31.obj" "codecif.obj" "fftstuff.obj" "mcaspPlayBk.obj" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

