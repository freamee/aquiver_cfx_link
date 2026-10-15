<template>
    <ElementContainer>
        <ElementText>
            {{ props.title }}
        </ElementText>

        <ElementText>
            {{ props.message }}
        </ElementText>

        <ElementIcon :icon="props.icon" />
    </ElementContainer>
</template>

<script setup lang="ts">
import {
    ElementContainer,
    ElementText,
    ElementIcon
} from "@aquiver/ui";

interface IProps {
    id: number;
    title: string;
    message: string;
    duration: number;
    icon: string;
}

const props = defineProps<IProps>();
</script>

<style lang="scss" scoped></style>